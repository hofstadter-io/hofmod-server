package auth

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

{{ $AUTH := .SERVER.AuthConfig.Authentication }}

func Routes(e *echo.Echo) {
	// create auth groups
	g := e.Group("/auth")
	anon := g.Group("")
	authed := g.Group("", authMiddleware...)

	// test route
	authed.GET("/test", testAuth)

	{{ if $AUTH.Apikey }}
	apikeyRoutes(anon, authed)
	{{ end }}

	{{ if $AUTH.Password }}
	// Password routes
	passwordRoutes(anon, authed)
	{{ end }}

	{{ if $AUTH.JWT }}
	// JWT routes
	{{ end }}

}

func testAuth(c echo.Context) (err error) {
	// should only get here if we have already authenticated
	return c.String(http.StatusOK, "OK")
}
