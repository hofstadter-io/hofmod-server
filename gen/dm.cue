package gen

import (
  hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

#ModelGen: {
	Server: schema.#Server
	let ServerInput = Server

	UserModels: hof.#Datamodel
	let UserModelsInput = UserModels

	Datamodel: hof.#Datamodel & {
		Name: "ServerDatamodel"

		Modelsets: UserModelsInput.Modelsets & {
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

		if (Server.EntityConfig.users & true) != _|_ {
			User: hof.#Model & {
				ORM: true
				SoftDelete: true
				Fields: {
					email: hof.#Email & { nullable: false }
					name:  hof.#String
					if (Server.AuthConfig.Authentication.Password & true) != _|_ {
						password: hof.#Password
					}
				}
			}
		}

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


