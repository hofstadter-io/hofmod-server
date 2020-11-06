package example

import (
	cli_s "github.com/hofstadter-io/hofmod-cli/schema"
)

#Cli: cli_s.#Cli & {
	Name: #Server.Name
	Package: "\(#Server.Package)/cmd/example"

	Usage: "example"
	Short: "an example server"

	Updates: false

	OmitRun: true

	Commands: [{
		Name: "serve"
		Short: "run the server"
		Long: Short

		Imports: [{ Path: "github.com/hofstadter-io/hofmod-server/example/server/example", As: "server"}]

		Body: """
		server.Run()
		"""
	}]
}
