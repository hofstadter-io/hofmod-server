package example

import (
	srv_g "github.com/hofstadter-io/hofmod-server/gen"
	mod_g "github.com/hofstadter-io/hofmod-struct/gen"
)

Server: srv_g.#HofGenerator & {
	Outdir: "./output"
	Server: #Server

	// Needed because we are using the generator from within it's directory
	PackageName: ""
} @gen(server,golang)

// The Data models for the server and database
Models: mod_g.#HofGenerator & {
	Outdir: "./output/dm"
	Datamodel: #Datamodel
} @gen(server,models)
