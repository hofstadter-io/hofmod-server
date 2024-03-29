package gen

import (
  gen "github.com/hofstadter-io/hof/schema/gen"
  dm "github.com/hofstadter-io/hof/schema/dm"

	cli_s "github.com/hofstadter-io/hofmod-cli/schema"
  "github.com/hofstadter-io/hofmod-server/schema"
)

// Meta generator for sharing inputs
#HofGenerator: gen.#HofGenerator & {

	// Where to generate the output
  Outdir: string | *"./"

	// Server design / schema
  Server: schema.#Server

	// Builtin Datamodel design / resources
	Datamodel: dm.#Datamodel

	// Golang / Cuelang type module name, used for templates and import interpolation
	Module: string

	// Goreleaser config
	Releases: cli_s.#GoReleaser

	// mainly internal, used when designing in the generators own repository (i.e. for the example)
	PackageName: string | *"github.com/hofstadter-io/hofmod-server"

	// Sub-generators
	Generators: {

		ServerGen: #ServerGen & {
			"Outdir": Outdir
			"Module": Module
			"PackageName": PackageName
			"Server": Server
			"Datamodel": Datamodel
		}

		CliGen: #CliGen & {
			"Outdir": Outdir
			"Module": Module
			"Server": Server
			"Releases": Releases
			// Datamodel: DM
		}

	}

}
