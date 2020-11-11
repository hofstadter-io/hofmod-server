package gen

import (
	"list"

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

		_ServerFields: ["Name", "Package", "EntityConfig", "AuthConfig"]
		Modelsets: UserModelsInput.Modelsets & {
			Builtin: #BuiltinModels & { Server: { for k,v in ServerInput {
				if list.Contains(_ServerFields, k) {
					"\(k)": v
				}
			} } }
			// leave open so user defined models can be added
			...
		}
	}
}

#BuiltinModels: hof.#Modelset & {
	Name: "Builtin"
	Server: schema.#Server
	MigrateOrder: [
		Models.User,
		Models.Group,
		Models.Apikey,
	]
	Models: {

		if (Server.EntityConfig.users & true) != _|_ {
			User: hof.#Model & {
				ORM: true
				SoftDelete: true
				Fields: {
					email: hof.#Email & {
						nullable: false
						GormTag: "gorm:\"uniqueIndex;not null\""
					}
					name:  hof.#String
					if (Server.AuthConfig.Authentication.Password & true) != _|_ {
						password: hof.#Password
					}
					role: hof.#String
					active: hof.#Bool
				}
			}
		}

		if (Server.EntityConfig.groups & true) != _|_ {
			Group: hof.#Model & {
				ORM: true
				SoftDelete: true
				Fields: {
					name:  hof.#String
					about: hof.#String
				}
				Relations: {
					Users: {
						relation: "Many2Many"
						type: "User"
						table: "user_groups"
					}
				}
			}
			User: {
				Relations: {
					Groups: {
						relation: "Many2Many"
						type: "Group"
						table: "user_groups"
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
					key:  hof.#UUID & { GormTag: "gorm:\"type:uuid;index;default:gen_random_uuid()\"" }
				}
				Relations: {
					User: {
						relation: "BelongsTo"
						type: "User"
						GormTag: "gorm:\"type:uuid;foreignKey:UserID\""
					}
				}
			}
			User: {
				Relations: {
					Apikeys: {
						relation: "HasMany"
						type: "Apikey"
						foreignKey: "UserID"
					}
				}
			}
		}

	}
}


