{{ $ROUTE := . }}
{{ if $ROUTE.Routes }}
func {{ $ROUTE.Name }}Subroutes(e *echo.Group) {
	g := e.Group("{{ $ROUTE.Path }}{{ range $PATH := $ROUTE.Params }}/:{{$PATH}}{{ end }}")
	{{ range $SUB := $ROUTE.Routes }}
	g.{{$SUB.Method}}("{{ $SUB.Path }}{{ range $PATH := $SUB.Params }}/:{{$PATH}}{{ end }}", {{ $ROUTE.Name }}.{{ $SUB.Name }}Handler)
	{{ end }}
}
{{ end }}
