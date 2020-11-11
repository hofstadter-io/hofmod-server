package auth

func JWTMiddleware() {
	e.Use(middleware.JWTWithConfig(middleware.JWTConfig{
		SigningKey: []byte("secret"),
		TokenLookup: "query:token",
	}))

}
