{{ if .RESOURCE.Parent }}
package {{ .RESOURCE.Parent }}
{{ else }}
package resources
{{ end }}

import (
	"gorm.io/gorm"
	"github.com/labstack/echo/v4"
)

{{ range $ROUTE := .RESOURCE.Routes }}
{{ template "handler.go" $ROUTE }}
{{ end }}
