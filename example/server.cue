package example

import (
	"strings"

	srv_s "github.com/hofstadter-io/hofmod-server/schema"
)

ServerDesign: srv_s.#Server & {
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

	EmailConfig: {
		Content: srv_s.DefaultEmails
		...
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
		Model: CustomModels.Models.Todo
		Routes: (srv_s.#DefaultResourceRoutes & { Model: CustomModels.Models.Todo }).Routes
	},{
		Model: BuiltinModels.Models.User
		Routes: [ for R in (srv_s.#DefaultResourceRoutes & { Model: BuiltinModels.Models.User }).Routes if strings.HasSuffix(R.Name, "Admin") && !strings.Contains(R.Name, "Create") { R } ]
	}]
}
