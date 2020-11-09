package schema

#Authentication: {
	Password: bool | *true
	Apikey: bool | *true
}

#Authorization: {
	UserRoles: [...string] | *["super", "admin", "user", "anon"]
	GroupRoles: [...string] | *["owner", "admin", "user"]
}
