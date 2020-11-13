package example

import (
	srv_g "github.com/hofstadter-io/hofmod-server/gen"
)

Server: srv_g.#HofGenerator & {
	Outdir: "./output"
	Module: "github.com/hofstadter-io/hofmod-server"

	Server: #Server
	Datamodel: #Datamodel

	// Needed because we are using the generator from within it's directory
	PackageName: ""
} @gen(server,golang)
