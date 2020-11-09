package example

import (
	srv_g "github.com/hofstadter-io/hofmod-server/gen"
)

Server: srv_g.#HofGenerator & {
	Outdir: "./output"
	Server: #Server
	Datamodel: #Datamodel

	Module: "github.com/hofstadter-io/hofmod-server"

	// Needed because we are using the generator from within it's directory
	PackageName: ""
} @gen(server,golang)
