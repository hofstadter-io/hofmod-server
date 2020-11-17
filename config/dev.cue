package dev

Config: {
	host: "http://localhost"
	port: "1323"
	logging: {
		level: "debug"
		// format: "..." // https://echo.labstack.com/middleware/logger
	}

	auth: {
		passwordEntropy: uint | *60
	}
}
