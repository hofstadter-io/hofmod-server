package example

import (
	dm "github.com/hofstadter-io/hof/schema/dm"

  srv_s "github.com/hofstadter-io/hofmod-server/schema"
)

CustomModels: dm.#Modelset & {
	MigrateOrder: [
		Models.Todo,
	]
	Models: {
		Todo: dm.#Model & {
			Name: "Todo"
			ORM: true
			SoftDelete: true
			Fields: {
				name:     dm.#String & { unique: true, validation: { required: true } }
				content:  dm.#String & { length: 2048, validation: { required: true } }
				complete: dm.#Bool
			}
			Relations: {
				User: {
					relation: "BelongsTo"
					type: "uuid.UUID"
					GormTag: "gorm:\"type:uuid;foreignKey:UserID\""
				}
			}
			Views: {
				Create: {
					Fields: CustomModels.Models.Todo.Fields
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
		User: dm.#Model & {
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
