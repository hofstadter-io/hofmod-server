package auth

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"gorm.io/gorm"

	"{{ .ModuleImport }}/dm"
	"{{ .ModuleImport }}/server/db"
)

// always return true so we can have multiple types of auth
func apikeyMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		// already auth'd?
		if c.Get("user") != nil {
			return next(c)
		}

		key := c.Request().Header.Get("apikey")
		// no key, move one
		if key == "" {
			return next(c)
		}
		_, err := uuid.Parse(key)
		if err != nil {
			return next(c)
		}

		user := &dm.User{}
		// apikey := &dm.Apikey{}
		err = db.DB.Table("users").Joins("left join apikeys on users.id = apikeys.user_id").Where("apikeys.key = ?", key).First(user).Error
		if err != nil {
			if !errors.Is(err, gorm.ErrRecordNotFound) {
				c.Logger().Error(err)
			}
			return next(c)
		}
		if user.Email == "" {
			return next(c)
		}


		// user auth'd
		user.Password = ""
		c.Set("user", user)

		return next(c)
	}
}

func apikeyRoutes(G *echo.Group) {
	g := G.Group("/apikey")

	g.GET("/", listApikey)
	g.POST("/", createApikey)
	g.DELETE("/", deleteApikey)
}

func listApikey(c echo.Context) (error) {
	user := c.Get("user")
	if user == nil {
		return fmt.Errorf("no user")
	}

	return c.String(http.StatusNotImplemented, "not implemented")
}

func createApikey(c echo.Context) (error) {
	user := c.Get("user")
	if user == nil {
		return fmt.Errorf("no user")
	}

	return c.String(http.StatusNotImplemented, "not implemented")
}

func deleteApikey(c echo.Context) (error) {
	user := c.Get("user")
	if user == nil {
		return fmt.Errorf("no user")
	}

	return c.String(http.StatusNotImplemented, "not implemented")
}
