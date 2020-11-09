package gen

import (
	"path"

  cli_g "github.com/hofstadter-io/hofmod-cli/gen"
	cli_s "github.com/hofstadter-io/hofmod-cli/schema"

  // hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

#CliGen: cli_g.#HofGenerator & {
	Outdir: string
	Server: schema.#Server
	Module: string

	Cli: cli_s.#Cli & {
		Name: Server.Name
		Package: "\(Server.Package)/cmd/\(Server.serverName)"

		Usage: "\(Server.serverName)"
		Short: Server.description | "server cli"

		Updates: false

		OmitRun: true

		Commands: [{
			Name: "serve"
			Short: "run the server"
			Long: Short

			Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/\(Server.serverName)"), As: "server"}]

			Body: """
			server.Run()
			"""
		}]
	}
}
