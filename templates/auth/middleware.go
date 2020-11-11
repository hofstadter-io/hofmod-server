package auth

import (
	"fmt"
	"net/http"

	"github.com/kr/pretty"
	"github.com/labstack/echo/v4"

	"{{ .ModuleImport }}/dm"
)

{{ $AUTH := .SERVER.AuthConfig.Authentication }}


var (

	authMiddleware = []echo.MiddlewareFunc {
		{{ if $AUTH.Apikey }}
		apikeyMiddleware,
		{{ end }}
		{{ if $AUTH.Password }}
		passwordMiddleware,
		{{ end }}
		{{ if $AUTH.JWT }}
		{{ end }}

		// must be last, this checks for a 'user' on the context
		authChecker,
	}

	authChecker echo.MiddlewareFunc = func (next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			user := c.Get("user").(*dm.User)
			if user == nil {
				return c.String(http.StatusUnauthorized, "401 - Unauthorized")
			}
			if !user.Active {
				return c.String(http.StatusUnauthorized, "401 - Unauthorized, your account is not active and needs to be confirmed")
			}
			fmt.Printf("auth user:\n%# v\n", pretty.Formatter(user))
			return next(c)
		}
	}

)
