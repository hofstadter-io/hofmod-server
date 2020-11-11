package server

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"{{ .ModuleImport }}/server/auth"
)

func setupRouter(e *echo.Echo) error {

	e.GET("/alive", func(c echo.Context) error {
		return c.NoContent(http.StatusOK)
	})

	auth.Routes(e)

	// api := e.Group("/api")
	// setup auth middleware on group

	return nil
}
