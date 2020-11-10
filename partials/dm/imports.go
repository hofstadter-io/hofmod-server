import (
	{{ if .MODEL.ORM }}
	"time"
	"github.com/google/uuid"
	{{ if .MODEL.SoftDelete }}
	"gorm.io/gorm"
	{{ end }}
	{{ end }}

	{{ range $import := .MODEL.Imports }}
	{{ $import.As }} "{{ $import.Path }}"
	{{ end }}
)
