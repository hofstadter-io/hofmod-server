package schema

#Authentication: {
	Password: bool | *true
	ApiKey: bool | *true
}

#Authorization: {
	Roles: [...string] | *["admin", "user", "anon"]
}
