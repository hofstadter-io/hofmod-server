package gen

import (
  hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

// Meta generator for sharing inputs
#HofGenerator: hof.#HofGenerator & {
	// User Inputs

	// Where to generate the output
  Outdir: string | *"./"
	let GenOutdir = Outdir

	// Server design / schema
  Server: schema.#Server
	let ServerInput = Server

	// Datamodel design / resources
	Datamodel: hof.#Datamodel
	let DatamodelInput = Datamodel

	// Golang / Cuelang type module name, used for templates and import interpolation
	Module: string
	let ModuleInput = Module

	// mainly internal, used when designing in the generators own repository (i.e. for the example)
	PackageName: string
	let PackageNameInput = PackageName

	// Sub-generators
	Generators: {

		ServerGen: #ServerGen & {
			Outdir: GenOutdir
			Module: ModuleInput
			PackageName: PackageNameInput
			Server: ServerInput
			UserModels: DatamodelInput
			BuiltinModels: #BuiltinModels & { Server: ServerInput }
		}

		CliGen: #CliGen & {
			Outdir: GenOutdir
			Module: ModuleInput
			Server: ServerInput
		}

	}
}
