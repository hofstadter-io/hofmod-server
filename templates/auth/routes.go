package auth

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

{{ $AUTH := .SERVER.AuthConfig.Authentication }}

func Routes(e *echo.Echo) {
	// account routes
	e.GET("/acct/register", AccountRegisterHandler)
	e.GET("/acct/confirm", AccountConfirmHandler)
	e.GET("/acct/resend-confirm", AccountResendConfirmHandler)

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
	// Apikey routes
	apikeyRoutes(g)
	{{ end }}

	{{ if $AUTH.Password }}
	// Password routes
	passwordRoutes(g)
	{{ end }}

	{{ if $AUTH.JWT }}
	// JWT routes
	// TODO
	{{ end }}

}

func testAuth(c echo.Context) (err error) {
	// should only get here if we have already authenticated
	return c.String(http.StatusOK, "OK")
}
