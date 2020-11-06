package schema

#Rest: {
	Routes: [...#RestRoute]
}

#RestRoute: {
	Name: string
	Path: string // TODO, add constraints / regex
	Method: #HttpMethod
	Query: [...string] | *[]
}
