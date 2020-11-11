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
	Description: string

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
		type: "postgres" | "mysql" | "sqlite" | "sqlserver"
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
	Body: string | *"""
	c.String(http.StatusNotImplemented, "Not Implemented")
	"""

	Routes: [...#Route]
}

#Resources: [...#Resource] | *[]
#Resource: {
	Name: string
	Path: string // TODO, add constraints / regex
	Model: hof.#Model

	Roles: [method=string]: [...string] | *[]
}
