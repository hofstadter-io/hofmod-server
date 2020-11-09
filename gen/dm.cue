package gen

import (
	mod_g "github.com/hofstadter-io/hofmod-struct/gen"

  hof "github.com/hofstadter-io/hof/schema"
)

#ModelGen: mod_g.#HofGenerator & {
	Usermodel: hof.#Datamodel
	Datamodel: hof.#Datamodel & {
		Name: "ServerDatamodel"

		Modelsets: Usermodel.Modelsets & {
			Builtin: hof.#Modelset & {
				Models: {

					Apikey: {
						Fields: {
							hof.#CommonFields
							name: hof.#String
							key:  hof.#UUID
						}
					}

				}
			}

			// leave open so user defined models can be added
			...
		}
	}
}
