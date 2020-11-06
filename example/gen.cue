package example

import (
	"github.com/hofstadter-io/hofmod-server/gen"
)

Server: gen.#HofGenerator & {
	Server: #Server
	Outdir: "./example"

	// Needed because we are using the generator from within it's directory
	PackageName: ""
} @gen(server,golang)
