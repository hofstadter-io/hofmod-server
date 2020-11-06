package schema

#Authentication: {
	ApiKey: bool | *true
}

#Authorization: {
	Roles: [...string] | *["admin", "user", "anon"]
}
