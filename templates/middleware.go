package server

import (
	"github.com/labstack/echo/v4"

	"github.com/labstack/echo-contrib/prometheus"
)

func setupMiddleware(e *echo.Echo) error {

	// Enable metrics middleware
	p := prometheus.NewPrometheus("echo", nil)
	p.Use(e)

	return nil
}
