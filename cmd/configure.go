package cmd

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/AlecAivazis/survey/v2"
	"github.com/spf13/cobra"
)

type infraService struct {
	DisplayName string
	Version     string
	ComposeName string
}

var availableServices = []infraService{
	{DisplayName: "PostgreSQL", Version: "16-alpine", ComposeName: "postgres"},
	{DisplayName: "MySQL", Version: "8.4", ComposeName: "mysql"},
	{DisplayName: "Oracle XE", Version: "21-slim", ComposeName: "oracle"},
	{DisplayName: "Redis", Version: "7-alpine", ComposeName: "redis"},
	{DisplayName: "RabbitMQ", Version: "3-management", ComposeName: "rabbitmq"},
}

var configureCmd = &cobra.Command{
	Use:   "configure",
	Short: "Abre o menu interativo para selecionar serviços",
	RunE: func(cmd *cobra.Command, args []string) error {
		var selectedServices []string

		prompt := &survey.MultiSelect{
			Message: "Quais serviços você deseja subir para desenvolvimento?",
			Options: serviceDisplayNames(),
			Help:    "Use as setas para navegar, Espaço para selecionar e Enter para confirmar.",
		}

		err := survey.AskOne(prompt, &selectedServices)
		if err != nil {
			return fmt.Errorf("nao foi possivel concluir a selecao de servicos: %w", err)
		}

		if len(selectedServices) == 0 {
			fmt.Println("Nenhum serviço selecionado.")
			return nil
		}

		fmt.Println("\n✅ Serviços selecionados com sucesso!")
		for _, service := range selectedServices {
			fmt.Printf("  - %s\n", service)
		}

		composeServices, err := toComposeServices(selectedServices)
		if err != nil {
			return err
		}

		if _, err := exec.LookPath("docker"); err != nil {
			return errors.New("docker nao encontrado no PATH. Instale Docker Desktop/Engine e tente novamente")
		}

		composeFilePath, err := installedComposeFilePath()
		if err != nil {
			return err
		}

		if _, err := os.Stat(composeFilePath); err != nil {
			if errors.Is(err, os.ErrNotExist) {
				return fmt.Errorf("arquivo de compose nao encontrado em %s. Rode `make install` novamente para instalar os services do Docker", composeFilePath)
			}
			return fmt.Errorf("erro ao verificar arquivo de compose: %w", err)
		}

		upArgs := []string{"compose", "-f", composeFilePath, "up", "-d"}
		upArgs = append(upArgs, composeServices...)

		dockerUpCmd := exec.Command("docker", upArgs...)
		dockerUpCmd.Stdout = os.Stdout
		dockerUpCmd.Stderr = os.Stderr

		fmt.Println("\n🚀 Subindo containers selecionados...")
		if err := dockerUpCmd.Run(); err != nil {
			return fmt.Errorf("falha ao subir containers com docker compose: %w", err)
		}

		fmt.Printf("\n✅ Containers ativos via compose: %s\n", composeFilePath)
		return nil
	},
}

func serviceDisplayNames() []string {
	names := make([]string, 0, len(availableServices))
	for _, service := range availableServices {
		names = append(names, fmt.Sprintf("%s (%s)", service.DisplayName, service.Version))
	}
	return names
}

func toComposeServices(selectedDisplayNames []string) ([]string, error) {
	displayToCompose := make(map[string]string, len(availableServices))
	for _, service := range availableServices {
		displayNameWithVersion := fmt.Sprintf("%s (%s)", service.DisplayName, service.Version)
		displayToCompose[displayNameWithVersion] = service.ComposeName
	}

	composeNames := make([]string, 0, len(selectedDisplayNames))
	for _, selected := range selectedDisplayNames {
		composeName, ok := displayToCompose[selected]
		if !ok {
			return nil, fmt.Errorf("servico selecionado sem mapeamento no compose: %s", selected)
		}
		composeNames = append(composeNames, composeName)
	}

	return composeNames, nil
}

func installedComposeFilePath() (string, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return "", fmt.Errorf("nao foi possivel localizar o diretorio HOME: %w", err)
	}

	composeFilePath := filepath.Join(homeDir, ".atlas", "services", "docker", "docker-compose.yml")
	if strings.TrimSpace(composeFilePath) == "" {
		return "", errors.New("caminho de compose invalido")
	}

	return composeFilePath, nil
}

func init() {
	// Adiciona 'configure' dentro de 'services' (atlas services configure)
	servicesCmd.AddCommand(configureCmd)
}
