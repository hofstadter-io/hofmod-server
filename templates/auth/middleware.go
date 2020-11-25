package auth

import (
	"fmt"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"

	"{{ .ModuleImport }}/dm"
)

{{ $AUTH := .SERVER.AuthConfig.Authentication }}


var (

	AuthMiddleware = []echo.MiddlewareFunc {
		{{ if $AUTH.Apikey }}
		apikeyMiddleware,
		{{ end }}
		{{ if $AUTH.Password }}
		passwordMiddleware,
		{{ end }}
		{{ if $AUTH.JWT }}
		{{ end }}
	}

	AdminChecker echo.MiddlewareFunc = MakeRoleChecker([]string{"super", "admin"})

)

func MakeRoleChecker(roles []string) echo.MiddlewareFunc {
	return func (next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			U := c.Get("user")
			if U == nil {
				return c.String(http.StatusUnauthorized, "401 - Unauthorized")
			}

			user := U.(*dm.User)

			if user.Disabled {
				return c.String(http.StatusUnauthorized, "401 - Unauthorized, your account has been disabled, please contact support")
			}

			if !user.Active {
				return c.String(http.StatusUnauthorized, "401 - Unauthorized, your account is not active and needs to be confirmed")
			}

			// check roles
			found := false
			for _, R := range roles {
				if user.Role == R {
					found = true
				}
			}
			if !found {
				return c.String(http.StatusUnauthorized, "401 - Unauthorized")
			}
			return next(c)
		}
	}
}

// Helper for checking auth
func AuthChecker(c echo.Context, roles []string) (*dm.User, error) {
	U := c.Get("user")
	if U == nil {
		return nil, c.String(http.StatusUnauthorized, "401 - Unauthorized")
	}

	user := U.(*dm.User)

	if !user.Active {
		return user, c.String(http.StatusUnauthorized, "401 - Unauthorized, your account is not active and needs to be confirmed")
	}

	if len(roles) > 0 {
		found := false
		for _, R := range roles {
			if user.Role == R {
				found = true
			}
		}
		if !found {
			return nil, c.String(http.StatusUnauthorized, "401 - Unauthorized")
		}
	}

	return user, nil
}

func LookupOrgAndGroups(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		U := c.Get("user")
		if U == nil {
			return fmt.Errorf("User should never be nil here")
		}

		user := U.(*dm.User)

		orgkey := c.QueryParam("org")
		// no key, bad request
		if orgkey == "" {
			return c.String(http.StatusBadRequest, "org query param required")
		}
		// check
		_, err := uuid.Parse(orgkey)
		if err != nil {
			return c.String(http.StatusBadRequest, "org query param has invalid format")
		}

		fmt.Println(user.ID)

		// lookup orgs, groups, and roles in each
		return next(c)
	}
}
