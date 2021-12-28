package example

import (
	srv_g "github.com/hofstadter-io/hofmod-server/gen"
)

Server: srv_g.#HofGenerator & {
	@gen(server,golang)

	Outdir: "./output"
	Module: "github.com/hofstadter-io/hofmod-server"

	Server: ServerDesign
	Datamodel: {
		Name: "ServerDatamodel"
		Modelsets: {
			Custom: CustomModels
			Builtin: BuiltinModels
		}
	}

	Releases: {
		Disable: false
		Draft:    false
		Author:   "Hofstadter, Inc"
		Homepage: "https://hofstadter.io"

		GitHub: {
			Owner: "hofstadter-io"
			Repo:  "hofmod-server"
		}

		Docker: {
			Maintainer: "Hofstadter, Inc <open-source@hofstadter.io>"
			Repo:       "hofstadter"
		}
	}



	// Needed because we are using the generator from within it's directory
	PackageName: ""
}
