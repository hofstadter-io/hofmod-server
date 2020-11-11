package server

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/labstack/echo-contrib/prometheus"

	"{{ .ModuleImport }}/server/auth"
)

func setupMiddleware(e *echo.Echo) error {
	// setup recovery middleware
	e.Use(middleware.Recover())

	// Setup metrics middleware
	p := prometheus.NewPrometheus("{{ .SERVER.Name }}", nil)
	e.Use(p.HandlerFunc)

	// setup auth middleware
	e.Use(auth.AuthMiddleware...)

	return nil
}
