package example

import (
  cli_g "github.com/hofstadter-io/hofmod-cli/gen"
	srv_g "github.com/hofstadter-io/hofmod-server/gen"
	mod_g "github.com/hofstadter-io/hofmod-struct/gen"
)

Server: srv_g.#HofGenerator & {
	Outdir: "./example"
	Server: #Server

	// Needed because we are using the generator from within it's directory
	PackageName: ""
} @gen(server,golang)

// CLI generator to act as binary entrypoint
Cli: cli_g.#HofGenerator & {
	Outdir: "./example"
	Cli: #Cli
} @gen(server,cli)

// The Data models for the server and database
Models: mod_g.#HofGenerator & {
	Outdir: "./example/dm"
	Datamodel: #Datamodel
} @gen(server,models)
