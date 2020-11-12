{{ $ROUTE := . }}
func {{ $ROUTE.Name }}Handler(c echo.Context) (err error) {

	{{ range $P := $ROUTE.Params }}
	{{ $P }} := c.Param("{{ $P }}")
	{{ end }}

	{{ range $Q := $ROUTE.Query }}
	{{ $Q }} := c.QueryParam("{{ $Q }}")
	{{ end }}


	{{ if $ROUTE.ReqBind }}
	input := new(dm.{{$ROUTE.ReqBind.ModelName}})
	if err = c.Bind(input); err != nil {
		return err
	}
	{{ end }}

	{{ if $ROUTE.Body }}
	{{ $ROUTE.Body }}
	{{ else }}
	c.String(http.StatusNotImplemented, "Not Implemented")
	{{ end }}

	return nil
}
