package schema

import (
	"list"

  hof "github.com/hofstadter-io/hof/schema"
)

#BuiltinModels: hof.#Modelset & {
	Name: "Builtin"
	Server: #Server
	_ServerFields: ["EntityConfig", "AuthConfig"]
	_Server: { for k,v in Server {
		if list.Contains(_ServerFields, k) {
			"\(k)": v
		}
	} }

	MigrateOrder: [
		Models.User,
		Models.Group,
		Models.Apikey,
	]
	Models: {

		if (_Server.EntityConfig.users & true) != _|_ {
			User: {
				ORM: true
				SoftDelete: true
				Fields: {
					email: hof.#Email & {
						nullable: false
						GormTag: "gorm:\"uniqueIndex;not null\""
					}
					name:  hof.#String
					if (_Server.AuthConfig.Authentication.Password & true) != _|_ {
						password: hof.#Password
					}
					role: hof.#String
					active: hof.#Bool
					disabled: hof.#Bool
				}
			}
		}

		if (_Server.EntityConfig.groups & true) != _|_ {
			Group: {
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

		if (_Server.AuthConfig.Authentication.Apikey & true) != _|_ {
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
	...
}
