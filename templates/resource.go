package resources

import (
	"net/http"

	// "gorm.io/gorm"
	"github.com/labstack/echo/v4"

	"{{ .ModuleImport }}/server/auth"
)

{{ $RESOURCE := .RESOURCE }}

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
