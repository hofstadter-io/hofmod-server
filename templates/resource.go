package resources

{{ $RESOURCE := .RESOURCE }}

import (
	"errors"
	"net/http"

	"github.com/labstack/echo/v4"
	"gorm.io/gorm"

	{{ range $I := $RESOURCE.Imports -}}
	"{{ $I }}"
	{{ end }}

	"{{ .ModuleImport }}/db"
	"{{ .ModuleImport }}/dm"
	"{{ .ModuleImport }}/server/auth"
)

func {{ $RESOURCE.Name }}Routes(G *echo.Group) {
	g := G.Group("{{ $RESOURCE.Path }}")
	{{ range $SUB := $RESOURCE.Routes }}
	g.{{$SUB.Method}}("{{ $SUB.Path }}{{ range $PATH := $SUB.Params }}/:{{$PATH}}{{ end }}",
		{{ $SUB.Name }}Handler,
		{{ if $SUB.Roles }}auth.MakeRoleChecker([]string{
			{{ range $SUB.Roles }} "{{.}}",
			{{ end }}
		}),
		{{ end }}
		)
	{{ end }}
}

{{ range $ROUTE := .RESOURCE.Routes }}
{{ template "handler.go" $ROUTE }}
{{ end }}
