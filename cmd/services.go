package cmd

import (
	"github.com/spf13/cobra"
)

var servicesCmd = &cobra.Command{
	Use:   "services",
	Short: "Gerencia os serviços de infraestrutura (bancos, cache, filas)",
	Run: func(cmd *cobra.Command, args []string) {
		printCommandSuggestions(cmd)
	},
}

func init() {
	// Adiciona o comando 'services' ao comando raiz 'atlas'
	rootCmd.AddCommand(servicesCmd)
}
