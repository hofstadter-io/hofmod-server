package {{ .ROUTE.PackageName }}

import (
	"net/http"

	"github.com/labstack/echo/v4"

	{{ if .ROUTE.Routes -}}
	{{ if.ROUTE.Parent.Parent }}
	"{{ .ModuleImport }}/server/routes/{{ .ROUTE.Parent.Parent.Name }}/{{ .ROUTE.Name }}"
	{{ else if .ROUTE.Parent }}
	"{{ .ModuleImport }}/server/routes/{{ .ROUTE.Parent.Name }}/{{ .ROUTE.Name }}"
	{{ else }}
	"{{ .ModuleImport }}/server/routes/{{ .ROUTE.Name }}"
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
	g := G.Group("")
	g.{{$ROUTE.Method}}(
		"{{ $ROUTE.Path }}{{ range $PATH := $ROUTE.Params }}/:{{$PATH}}{{ end }}",
		{{$ROUTE.Name}}Handler,
		{{ if $ROUTE.Roles }}auth.MakeRoleChecker([]string{
			{{ range $ROUTE.Roles }} "{{.}}",
			{{ end }}
		}),
		{{ end }}
	)
	{{ range $SUB := $ROUTE.Routes }}
	{{ $ROUTE.Name }}.{{ $SUB.Name }}Routes(g)
	{{ end }}
}

{{ template "handler.go" .ROUTE }}
