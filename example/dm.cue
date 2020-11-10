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
		Builtin: {
			Models: {
				User: #User
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
	Relations: {
		User: {
			relation: "BelongsTo"
			type: "User"
			GormTag: "gorm:\"type:uuid;foreignKey:UserID\""
		}
	}
}

#User: hof.#Model & {
	Relations: {
		Todo: {
			relation: "HasMany"
			type: "Todo"
			foreignKey: "UserID"
		}
	}
}
