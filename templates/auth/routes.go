package auth

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

{{ $AUTH := .SERVER.AuthConfig.Authentication }}

func Routes(e *echo.Echo) {
	// create auth groups
	g := e.Group("/auth")

	// test route
	g.GET("/test", testAuth,
		MakeRoleChecker([]string{
			"super",
			"admin",
			"user",
		}),
	)

	{{ if $AUTH.Apikey }}
	apikeyRoutes(g)
	{{ end }}

	{{ if $AUTH.Password }}
	// Password routes
	passwordRoutes(g)
	{{ end }}

	{{ if $AUTH.JWT }}
	// JWT routes
	{{ end }}

}

func testAuth(c echo.Context) (err error) {
	// should only get here if we have already authenticated
	return c.String(http.StatusOK, "OK")
}
