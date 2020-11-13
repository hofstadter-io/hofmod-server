package example

import (
	hof "github.com/hofstadter-io/hof/schema"

  srv_s "github.com/hofstadter-io/hofmod-server/schema"
)

CustomModels: hof.#Modelset & {
	MigrateOrder: [
		Models.Todo,
	]
	Models: {
		Todo: hof.#Model & {
			Name: "Todo"
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
					type: "uuid.UUID"
					GormTag: "gorm:\"type:uuid;foreignKey:UserID\""
				}
			}
		}
	}
}

BuiltinModels: srv_s.#BuiltinModels & {
	Server: {
		AuthConfig: ServerDesign.AuthConfig
		EntityConfig: ServerDesign.EntityConfig
	}
	Models: {
		User: hof.#Model & {
			Relations: {
				Todos: {
					relation: "HasMany"
					type: "Todo"
					foreignKey: "UserID"
				}
			}
		}
	}
}
