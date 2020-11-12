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

	Imports: [
		"strconv",
		"github.com/google/uuid",
	]

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
			Roles: ["super", "admin", "user"]
			Body: string | *(#DefaultCreateOwnBody & { M: Model }).Body
		}
		Update: {
			Name: "Update"
			Path: ""
			Method: "PATCH"
			Params: ["id"]
			ReqBind: Model
			Roles: ["super", "admin", "user"]
			Body: string | *(#DefaultUpdateOwnBody & { M: Model }).Body
		}
		Delete: {
			Name: "Delete"
			Path: ""
			Method: "DELETE"
			Params: ["id"]
			Roles: ["super", "admin", "user"]
			Body: string | *(#DefaultDeleteOwnBody & { M: Model }).Body
		}
		ListOwn: {
			Name: "ListOwn"
			Path: ""
			Method: "GET"
			Roles: ["super", "admin", "user"]
			Query: ["limit", "offset"]
			Body: string | *(#DefaultListOwnBody & { M: Model }).Body
		}
		GetOwn: {
			Name: "GetOwn"
			Path: ""
			Method: "GET"
			Params: ["id"]
			Roles: ["super", "admin", "user"]
			Body: string | *(#DefaultGetOwnBody & { M: Model }).Body
		}
	}

	Routes: [ for r, R in RoutesMap { R }]
}
