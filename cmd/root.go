package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

// rootCmd representa o comando base quando chamado sem subcomandos
var rootCmd = &cobra.Command{
	Use:   "atlas",
	Short: "Atlas Platform - Seu Internal Developer Platform local",
	Long:  `Atlas abstrai a complexidade da infraestrutura local, permitindo que você suba bancos de dados, cache, filas e serviços com facilidade.`,
	Run: func(cmd *cobra.Command, args []string) {
		printCommandSuggestions(cmd)
	},
}

// Execute adiciona todos os comandos filhos ao comando raiz e prepara a execução.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func printCommandSuggestions(cmd *cobra.Command) {
	available := make([]string, 0, len(cmd.Commands()))
	for _, subcommand := range cmd.Commands() {
		if subcommand.Hidden || subcommand.Name() == "help" || subcommand.Name() == "completion" {
			continue
		}
		available = append(available, fmt.Sprintf("  - %s", subcommand.Name()))
	}

	if len(available) == 0 {
		fmt.Println("Nenhuma sugestão disponível para este comando.")
		return
	}

	fmt.Println()
	fmt.Println("Sugestões disponíveis:")
	fmt.Println()
	fmt.Println(strings.Join(available, "\n"))
	fmt.Println()
}
