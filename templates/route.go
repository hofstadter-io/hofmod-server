package {{ .ROUTE.PackageName }}

import (
	"net/http"

	"github.com/labstack/echo/v4"

	{{ if .ROUTE.Routes -}}
	{{ if.ROUTE.Parent.Parent }}
	"{{ .ModuleImport }}/server/routes/{{ .ROUTE.Parent.Parent.name }}/{{ .ROUTE.name }}"
	{{ else if .ROUTE.Parent }}
	"{{ .ModuleImport }}/server/routes/{{ .ROUTE.Parent.name }}/{{ .ROUTE.name }}"
	{{ else }}
	"{{ .ModuleImport }}/server/routes/{{ .ROUTE.name }}"
	{{ end }}
	{{ end }}

	{{ if .ROUTE.Roles }}
	"{{ .ModuleImport }}/server/auth"
	{{ end }}

	{{ range $I := .ROUTE.Imports }}
	"{{ $I }}"
	{{ end }}
)

{{ $ROUTE := .ROUTE }}

func {{ $ROUTE.Name }}Routes(G *echo.Group) {
	g := G.Group("{{ $ROUTE.Path }}{{ range $PATH := $ROUTE.Params }}/:{{$PATH}}{{ end }}")
	g.{{$ROUTE.Method}}( "", {{$ROUTE.Name}}Handler,
		{{ if $ROUTE.Roles }}auth.MakeRoleChecker([]string{
			{{ range $ROUTE.Roles }} "{{.}}",
			{{ end }}
		}),
		{{ end }}
	)
	{{ range $SUB := $ROUTE.Routes }}
	{{ $ROUTE.name }}.{{ $SUB.Name }}Routes(g)
	{{ end }}
}

{{ template "handler.go" .ROUTE }}
