package schema

import (
  "strings"

	hof "github.com/hofstadter-io/hof/schema"
)

// Server Schema
#Server: {
  Name:     string
  serverName:  strings.ToCamel(Name)
  ServerName:  strings.ToTitle(Name)
  SERVER_NAME: strings.ToUpper(Name)

	// A short description
	Description: string | *""

  Package:  string

	EntityConfig: {
		users: bool | *true
		groups: bool | *true
		organizations: bool | *false
		serviceaccounts: bool | *false
	}

	AuthConfig: {
		Authentication: {
			Password: bool | *true
			Apikey: bool | *true
		}
		Authorization: {
			UserRoles: [...string] | *["super", "admin", "user", "anon"]
			GroupRoles: [...string] | *["owner", "admin", "user"]
		}
	}

	DatabaseConfig: {
		type: *"postgres" | "mysql" | "sqlite" | "sqlserver"
	}

	// Routes & Resources
	Routes: #Routes
	Resources: #Resources

	// The following are passed through to the CLI generator

	// Setup Goreleaser config
  Releases: bool | *true

	// directory of files to embed into the binary
	EmbedDir?: string

  // Debugging
  EnablePProf: bool | *false

	...
}

#HttpMethod: "OPTIONS" | "HEAD" | "GET" | "POST" | "PATCH" | "PUT" | "DELETE" | "CONNECT" | "TRACE"

#Routes: [...#Route] | *[]
#Route: {
	Name: string
	Path: string // TODO, add constraints / regex
	Method: #HttpMethod

	// Roles that are authorized
	Roles: [...string] | *[]

	Params: [...string] | *[]
	Query: [...string] | *[]
	ReqBind?: {...}
	RespBind?: {...}

	Imports: [...string] | *[]
	Body?: string

	Routes: [...#Route]
}

#Resources: [...#Resource] | *[]
#Resource: {
	Model: hof.#Model

	Name: string | *"\(Model.Name)"
	Path: string | *"/\(Model.modelName)"

	Routes: [...#Route]

	// TODO, HUGE slowdown
	//Routes: [...#Route] | *DefaultRoutes
	//DefaultRoutes: (#DefaultResourceRoutes & { Model: ModelInput }).Routes
	
}

#DefaultResourceRoutes: {
	Model: hof.#Model

	RoutesMap: {
		Create: {
			Name: "Create"
			Path: ""
			Method: "POST"
			ReqBind: Model
			RespBind: Model
			Roles: ["super", "admin", "user"]
			Body: string | *"""
			c.Logger().Warn("Creating \(Model.Name) ")
			c.String(http.StatusNotImplemented, "Not Implemented")
			"""
		}
		Update: {
			Name: "Update"
			Path: ""
			Method: "PATCH"
			Params: ["id"]
			ReqBind: Model
			RespBind: Model
			Roles: ["super", "admin", "user"]
			Body: string | *"""
			c.Logger().Warn("Updating \(Model.Name) ", id)
			c.String(http.StatusNotImplemented, "Not Implemented")
			"""
		}
		Delete: {
			Name: "Delete"
			Path: ""
			Method: "DELETE"
			Params: ["id"]
			Roles: ["super", "admin", "user"]
			Body: string | *"""
			c.Logger().Warn("Deleting \(Model.Name) ", id)
			c.String(http.StatusNotImplemented, "Not Implemented")
			"""
		}
		List: {
			Name: "List"
			Path: ""
			Method: "GET"
			RespBind: Model
			Roles: ["super", "admin", "user"]
			Body: string | *"""
			c.Logger().Warn("Listing \(Model.Name) ")
			c.String(http.StatusNotImplemented, "Not Implemented")
			"""
		}
		Get: {
			Name: "Get"
			Path: ""
			Method: "GET"
			Params: ["id"]
			RespBind: Model
			Roles: ["super", "admin", "user"]
			Body: string | *"""
			c.Logger().Warn("Getting \(Model.Name) ", id)
			c.String(http.StatusNotImplemented, "Not Implemented")
			"""
		}
	}

	Routes: [ for r, R in RoutesMap { R }]
}
