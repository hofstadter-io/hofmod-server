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

	Routes: [{
		Name: "EchoQ"
		Path: "/echo"
		Method: "GET"
		Query: ["msg"]
		Body: """
		c.String(http.StatusOK, msg)
		"""
	},{
		Name: "EchoP"
		Path: "/echo"
		Method: "GET"
		Params: ["msg"]
		Body: """
		c.String(http.StatusOK, msg)
		"""
	},{
		Name: "Hello"
		Path: "/hello"
		Method: "GET"
		Roles: ["super", "admin", "user"]
		Imports: [
			"github.com/hofstadter-io/hofmod-server/output/dm"
		]
		Body: """
		user := c.Get("user").(*dm.User)
		c.String(http.StatusOK, "hello " + user.Name)
		"""

		Routes: [{
			Name: "World"
			Path: "/world"
			Method: "GET"
			Roles: ["super", "admin", "user"]
			Query: ["msg"]
			Body: """
			if msg == "" {
				msg = "hello world"
			}
			c.String(http.StatusOK, msg)
			"""
		}]
	}]

	Resources: [{
		Model: #Todo
		// TODO, huge slowdown in definition with disjunction
		Routes: (srv_s.#DefaultResourceRoutes & { Model: #Todo }).Routes
	}]
}
