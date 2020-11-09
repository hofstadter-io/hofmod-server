package gen

import (
	mod_g "github.com/hofstadter-io/hofmod-struct/gen"

  hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

#ModelGen: mod_g.#HofGenerator & {
	Server: schema.#Server
	let ServerInput = Server

	Usermodel: hof.#Datamodel
	let UsermodelInput = Usermodel

	Datamodel: hof.#Datamodel & {
		Name: "ServerDatamodel"

		Modelsets: UsermodelInput.Modelsets & {
			Builtin: #BuiltinModels & { Server: ServerInput }
			// leave open so user defined models can be added
			...
		}
	}
}

#BuiltinModels: hof.#Modelset & {
	Name: "Builtin"
	Server: schema.#Server
	Models: {
		if (Server.AuthConfig.Authentication.Apikey & true) != _|_ {
			Apikey: {
				ORM: true
				SoftDelete: true
				Fields: {
					name: hof.#String
					key:  hof.#UUID
				}
			}
		}

	}
}
