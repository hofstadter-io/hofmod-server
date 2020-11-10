package example

import (
	hof "github.com/hofstadter-io/hof/schema"
)

#Datamodel: hof.#Datamodel & {
	Name: "Example"
	Modelsets: {
		Example: hof.#Modelset & {
			Models: {
				Todo: #Todo
			}
		}
	}
	...
}

#Todo: hof.#Model & {
	ORM: true
	SoftDelete: true
	Fields: {
		name:     hof.#String & { unique: true }
		content:  hof.#String & { length: 2048 }
		complete: hof.#Bool
	}
}
