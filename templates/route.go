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

	{{ range $I := .ROUTE.Imports }}
	"{{ $I }}"
	{{ end }}
)

{{ template "handler.go" .ROUTE }}

{{ template "subroutes.go" .ROUTE }}
