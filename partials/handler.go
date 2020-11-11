{{ $ROUTE := . }}
func {{ $ROUTE.Name }}Handler(c echo.Context) (err error) {

	{{ range $P := $ROUTE.Params }}
	{{ $P }} := c.Param("{{ $P }}")
	{{ end }}

	{{ range $Q := $ROUTE.Query }}
	{{ $Q }} := c.QueryParam("{{ $Q }}")
	{{ end }}

	{{ if $ROUTE.Body }}
	{{ $ROUTE.Body }}
	{{ else }}
	c.String(http.StatusNotImplemented, "Not Implemented")
	{{ end }}

	return nil
}
