package example

import (
  cli_g "github.com/hofstadter-io/hofmod-cli/gen"
	srv_g "github.com/hofstadter-io/hofmod-server/gen"
)

Server: srv_g.#HofGenerator & {
	Server: #Server
	Outdir: "./example"

	// Needed because we are using the generator from within it's directory
	PackageName: ""
} @gen(server,golang)

// CLI generator to act as binary entrypoint
Cli: cli_g.#HofGenerator & {
	Outdir: "./example"
	Cli: #Cli
} @gen(server,cli)

