package example

import (
	srv_s "github.com/hofstadter-io/hofmod-server/schema"
	srv_g "github.com/hofstadter-io/hofmod-server/gen"
)

Server: srv_g.#HofGenerator & {
	Outdir: "./output"
	Server: #Server
	CustomModels: #Datamodel
	BuiltinModels: srv_s.#BuiltinModels & { Server: #Server }

	Module: "github.com/hofstadter-io/hofmod-server"

	// Needed because we are using the generator from within it's directory
	PackageName: ""
} @gen(server,golang)
