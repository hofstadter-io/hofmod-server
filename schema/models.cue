package schema

import (
  dm "github.com/hofstadter-io/hof/schema/dm"
)

#BuiltinModels: dm.#Modelset & {
	Name: "Builtin"
	Server: {
		AuthConfig: _
		EntityConfig: _
	}

	MigrateOrder: [
		Models.User,

		Models.Apikey,

		if Server.EntityConfig.groups {
			Models.Group,
		}
		if Server.EntityConfig.groups {
			Models.GroupPerm,
		}

		if Server.EntityConfig.organizations {
			Models.Organization,
		}
		if Server.EntityConfig.organizations {
			Models.OrganizationPerm,
		}
	]

	Models: {

		if Server.EntityConfig.users {
			User: {
				ORM: true
				SoftDelete: true
				Fields: {
					email: dm.#Email & {
						nullable: false
						unique: true
						nullable: false
					}
					name:  dm.#String
					if Server.AuthConfig.Authentication.Password {
						password: dm.#Password
					}
					role: dm.#String & {
						length: 16
						nullable: false
					}
					active: dm.#Bool
					disabled: dm.#Bool
				}
			}
		}

		if Server.EntityConfig.groups {
			Group: {
				ORM: true
				SoftDelete: true
				Fields: {
					name:  dm.#String
					about: dm.#String
				}
				Relations: {
					Perms: {
						relation: "HasMany"
						type: "GroupPerm"
						foreignKey: "GroupID"
					}
				}
			}
			GroupPerm: {
				ORM: true
				SoftDelete: true
				Fields: {
					role: dm.#String
				}
				Relations: {
					User: {
						relation: "BelongsTo"
						type: "User"
						GormTag: "gorm:\"type:uuid;foreignKey:UserID\""
					}
					Group: {
						relation: "BelongsTo"
						type: "Group"
						GormTag: "gorm:\"type:uuid;foreignKey:GroupID\""
					}
				}
			}
			User: {
				Relations: {
					Groups: {
						relation: "HasMany"
						type: "Group"
						GormTag: "gorm:\"-\""
					}
					GroupPerms: {
						relation: "HasMany"
						type: "GroupPerm"
						foreignKey: "UserID"
					}
				}
			}
		}

		if Server.EntityConfig.organizations {
			Organization: {
				ORM: true
				SoftDelete: true
				Fields: {
					name:  dm.#String
					about: dm.#String
				}
				Relations: {
					Perms: {
						relation: "HasMany"
						type: "OrganizationPerm"
						foreignKey: "UserID"
					}
					Groups: {
						relation: "HasMany"
						type: "Group"
						foreignKey: "OrganizationID"
					}
				}
			}
			OrganizationPerm: {
				ORM: true
				SoftDelete: true
				Fields: {
					role: dm.#String
				}
				Relations: {
					User: {
						relation: "BelongsTo"
						type: "User"
						GormTag: "gorm:\"type:uuid;foreignKey:UserID\""
					}
					Group: {
						relation: "BelongsTo"
						type: "Group"
						GormTag: "gorm:\"type:uuid;foreignKey:GroupID\""
					}
				}
			}
			User: {
				Relations: {
					Organizations: {
						relation: "Many2Many"
						type: "Organization"
						table: "user_organizations"
					}
				}
			}
			Group: {
				Relations: {
					Organization: {
						relation: "BelongsTo"
						type: "Organization"
						GormTag: "gorm:\"type:uuid;foreignKey:OrganizationID\""
					}
				}
			}
		}

		if Server.AuthConfig.Authentication.Apikey {
			Apikey: {
				ORM: true
				SoftDelete: true
				Fields: {
					name: dm.#String
					key:  dm.#UUID & { GormTag: "gorm:\"type:uuid;index;default:gen_random_uuid()\"" }
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
