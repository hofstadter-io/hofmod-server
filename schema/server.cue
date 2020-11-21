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
			OrganizationRoles: [...string] | *["owner", "admin", "user", "member"]
		}
	}

	DatabaseConfig: {
		type: *"postgres" | "mysql" | "sqlite" | "sqlserver"
	}

	EmailConfig: {
		Content: [string]: string
	}

	// Routes & Resources
	Routes: #Routes
	Resources: #Resources

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
	name: string | *"\(strings.ToLower(Name))"
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

	ValidateInput?: bool

	Routes: [...#Route]
}

#Resources: [...#Resource] | *[]
#Resource: {
	Model: hof.#Model

	Name: string | *"\(Model.Name)"
	name: string | *"\(strings.ToLower(Name))"
	Path: string | *""

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

	Routes: [{
		Name: "\(Model.ModelName)CreateOwn"
		Path: "/\(Model.modelName)"
		Method: "POST"
		ReqBind: Model
		Roles: ["super", "admin", "user"]
		Body: string | *(#DefaultCreateOwnBody & { M: Model }).Body
		ValidateInput: true
	}, {
		Name: "\(Model.ModelName)UpdateOwn"
		Path: "/\(Model.modelName)"
		Method: "PATCH"
		Params: ["id"]
		ReqBind: Model
		Roles: ["super", "admin", "user"]
		Body: string | *(#DefaultUpdateOwnBody & { M: Model }).Body
		ValidateInput: true
	}, {
		Name: "\(Model.ModelName)DeleteOwn"
		Path: "/\(Model.modelName)"
		Method: "DELETE"
		Params: ["id"]
		Roles: ["super", "admin", "user"]
		Body: string | *(#DefaultDeleteOwnBody & { M: Model }).Body
	}, {
		Name: "\(Model.ModelName)ListOwn"
		Path: "/\(Model.modelName)"
		Method: "GET"
		Roles: ["super", "admin", "user"]
		Query: ["limit", "offset"]
		Body: string | *(#DefaultListOwnBody & { M: Model }).Body
	}, {
		Name: "\(Model.ModelName)GetOwn"
		Path: "/\(Model.modelName)"
		Method: "GET"
		Params: ["id"]
		Roles: ["super", "admin", "user"]
		Body: string | *(#DefaultGetOwnBody & { M: Model }).Body
	}, {
		Name: "\(Model.ModelName)CreateAdmin"
		Path: "/admin/\(Model.modelName)"
		Method: "POST"
		Query: ["userID"]
		ReqBind: Model
		Roles: ["super", "admin"]
		Body: string | *(#DefaultCreateAdminBody & { M: Model }).Body
		ValidateInput: true
	}, {
		Name: "\(Model.ModelName)UpdateAdmin"
		Path: "/admin/\(Model.modelName)"
		Method: "PATCH"
		Params: ["id"]
		ReqBind: Model
		Roles: ["super", "admin"]
		Body: string | *(#DefaultUpdateAdminBody & { M: Model }).Body
		ValidateInput: true
	}, {
		Name: "\(Model.ModelName)DeleteAdmin"
		Path: "/admin/\(Model.modelName)"
		Method: "DELETE"
		Params: ["id"]
		Roles: ["super", "admin"]
		Body: string | *(#DefaultDeleteAdminBody & { M: Model }).Body
	}, {
		Name: "\(Model.ModelName)ListAdmin"
		Path: "/admin/\(Model.modelName)"
		Method: "GET"
		Roles: ["super", "admin"]
		Query: ["userID", "limit", "offset"]
		Body: string | *(#DefaultListAdminBody & { M: Model }).Body
	}, {
		Name: "\(Model.ModelName)GetAdmin"
		Path: "/admin/\(Model.modelName)"
		Method: "GET"
		Params: ["id"]
		Roles: ["super", "admin"]
		Body: string | *(#DefaultGetAdminBody & { M: Model }).Body
	}]

}
