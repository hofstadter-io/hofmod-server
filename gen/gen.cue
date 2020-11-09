package gen

import (
  hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

#HofGenerator: hof.#HofGenerator & {
  Outdir: string | *"./"
	let GenOutdir = Outdir

  Server: schema.#Server
	let ServerInput = Server

	Datamodel: hof.#Datamodel
	let DatamodelInput = Datamodel

	PackageName: string
	let PackageNameInput = PackageName

	Generators: {
		ServerGen: #ServerGen & {
			Outdir: GenOutdir
			Server: ServerInput
			PackageName: PackageNameInput
		}
		CliGen: #CliGen & {
			Outdir: GenOutdir
			Server: ServerInput
		}
		ModelGen: #ModelGen & {
			Outdir: "\(GenOutdir)/dm"
			Usermodel: DatamodelInput
		}
	}
}
