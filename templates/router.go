package server

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func setupRouter(e *Echo) error {

	e.GET("/alive", func(c echo.Context) error {
		return c.NoContent(http.StatusOK)
	})

	api := e.Group("/api")
	// setup auth middleware on group

	return nil
}
