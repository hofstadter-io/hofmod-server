type {{ .MODEL.ModelName }} struct {
	{{ if .MODEL.ORM }}
	ID uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`

	CreatedAt time.Time `gorm:"default:current_timestamp"`

	UpdatedAt time.Time `gorm:"default:current_timestamp"`
	{{ if .MODEL.SoftDelete }}
	DeletedAt gorm.DeletedAt `gorm:"index"`
	{{ end }}
	{{ end }}

	{{ range $i, $F := .MODEL.Fields }}
	{{ template "dm/field.go" $F }}
	{{end}}

	{{ range $i, $R := .MODEL.Relations }}
	{{ template "dm/relations.go" $R }}
	{{end}}
}
