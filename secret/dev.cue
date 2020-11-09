package dev

Config: {
	database: {
		host: "localhost"
		port: "5432"
		dbname: "example"

		username: "example"
		password: "example"

		dsn: "host=\(host) user=\(username) password=\(password) dbname=\(dbname) port=\(port) sslmode=disable TimeZone=UTC"
	}
}
