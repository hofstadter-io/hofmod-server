package schema

// External Server Configuration, loaded at runtime
#ConfigSchema: #ConfigPublic & #ConfigSecret

// Configuration values that are OK to be public
#ConfigPublic: {
	// App secret 

	// Server port
	port: string | *"1323"

	// Logger config
	logging: {
		level?: string | *"warn"
		format?: string
	}

	//mailer: {
		//senders: {
			//accounts: string
			//billing: string
			//support: string
		//}
	//}

	...
}

// Configuration values that should be kept secret
#ConfigSecret: {
	secret: string
	database: {
		// DB host
		host: string
		// DB port
		port: string
		// DB name
		dbname: string
		// DB admin user
		username: string
		// DB admin pass
		password: string

		// DB connection string, defaults to postgres format
		dsn: "host=\(host) user=\(username) password=\(password) dbname=\(dbname) port=\(port) sslmode=disable TimeZone=UTC"
	}

	mailer: {
		mailgun?: {
			domain: string
			secret: string
			pubkey: string
		}
	}

	...
}
