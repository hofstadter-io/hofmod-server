package gen

import (
  cli_g "github.com/hofstadter-io/hofmod-cli/gen"
	cli_s "github.com/hofstadter-io/hofmod-cli/schema"

  // hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

#CliGen: cli_g.#HofGenerator & {
	Outdir: string
	Server: schema.#Server

	Cli: cli_s.#Cli & {
		Name: Server.Name
		Package: "\(Server.Package)/cmd/example"

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
}
