package server

import (
	"fmt"
	"net/http"
	"sort"

	"github.com/labstack/echo/v4"
	"github.com/prometheus/client_golang/prometheus/promhttp"

	"{{ .ModuleImport }}/server/auth"
	"{{ .ModuleImport }}/server/routes"
	// "{{ .ModuleImport }}/server/resources"
)

{{ $SERVER := .SERVER }}

func setupRouter(e *echo.Echo) error {

	// Internal routes
	e.GET("/internal/alive", func(c echo.Context) error {
		return c.NoContent(http.StatusOK)
	}, auth.AdminChecker)
	e.GET("/internal/metrics", prometheusHandler(), auth.AdminChecker)

	// Auth routes
	auth.Routes(e)

	// Explicit routes
	Routes := e.Group("")

	{{ range $ROUTE := $SERVER.Routes -}}
	Routes.{{$ROUTE.Method}}("{{ $ROUTE.Path }}{{ range $PATH := $ROUTE.Params }}/:{{$PATH}}{{ end }}", routes.{{$ROUTE.Name}}Handler)
	{{ if $ROUTE.Routes -}}
	routes.{{ $ROUTE.Name }}Subroutes(Routes)
	{{ end }}
	{{ end }}

	// Resource routes

	return nil
}

func prometheusHandler() echo.HandlerFunc {
	h := promhttp.Handler()
	return func(c echo.Context) error {
		h.ServeHTTP(c.Response(), c.Request())
		return nil
	}
}

func PrintRoutes() {
	var err error

	// create echo server
	e := echo.New()

	err = setupLogging(e)
	if err != nil {
		panic(err)
	}

	// add middleware
	err = setupMiddleware(e)
	if err != nil {
		panic(err)
	}

	// setup router
	err = setupRouter(e)
	if err != nil {
		panic(err)
	}

	routes := e.Routes()
	sort.Slice(routes, func(i, j int) bool {
		if routes[i].Path == routes[j].Path {
			return routes[i].Method < routes[j].Method
		}
		return routes[i].Path < routes[j].Path
	})

	for _, route := range routes {
		fmt.Printf("%-10s  %s\n", route.Method, route.Path)
	}

}

