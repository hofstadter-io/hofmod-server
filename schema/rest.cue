package schema

import (
	hof "github.com/hofstadter-io/hof/schema"
)

#Rest: {
	Routes: [...#RestRoute] | *[]
	Resources: [...#RestResource] | *[]
}

#RestRoute: {
	Name: string
	Path: string // TODO, add constraints / regex
	Method: #HttpMethod
	Query: [...string] | *[]

	ReqBody: {...}
	RespBody: {...}
}

#RestResource: {
	Name: string
	Path: string // TODO, add constraints / regex
	Model: hof.#Model
}
