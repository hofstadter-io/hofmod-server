package example

import (
	srv_s "github.com/hofstadter-io/hofmod-server/schema"
)

#Server: srv_s.#Server & {
	Name: "Example"
	Package: "github.com/hofstadter-io/hofmod-server/output"
	Description: "An example server"

	AuthConfig: {
		Authentication: {
			Apikey: true
		}
		Authorization: {
			UserRoles: ["super", "admin", "user", "anon"]
			GroupRoles: ["owner", "admin", "user"]
		}
	}

	DatabaseConfig: {
		type: "postgres"
	}
}
