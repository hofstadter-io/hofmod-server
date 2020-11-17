package schema

import (
  hof "github.com/hofstadter-io/hof/schema"
)

#BuiltinModels: hof.#Modelset & {
	Name: "Builtin"
	Server: {
		AuthConfig: _
		EntityConfig: _
	}

	MigrateOrder: [
		Models.User,
		Models.Group,
		Models.Apikey,
	]
	Models: {

		if (Server.EntityConfig.users & true) != _|_ {
			User: {
				ORM: true
				SoftDelete: true
				Fields: {
					email: hof.#Email & {
						nullable: false
						unique: true
						nullable: false
					}
					name:  hof.#String
					if (Server.AuthConfig.Authentication.Password & true) != _|_ {
						password: hof.#Password
					}
					role: hof.#String & {
						length: 16
						nullable: false
					}
					active: hof.#Bool
					disabled: hof.#Bool
				}
			}
		}

		if (Server.EntityConfig.groups & true) != _|_ {
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
	...
}
