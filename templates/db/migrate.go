package db

{{ $ModuleImport := .ModuleImport }}

import (
	"{{ $ModuleImport }}/dm/Builtin"
	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	"{{ $ModuleImport }}/dm/{{ $mset.Name }}"
	{{ end }}
)


func RunMigrations() (err error) {
	// Builtin Models
	DB.AutoMigrate(
	{{ range $i, $model := .MODELS.Builtin.Models -}}
		&Builtin.{{ $model.Name }}{},
	{{ end }}
	)

	// User Models
	DB.AutoMigrate(
	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	{{ range $j, $model := $mset.Models -}}
		&{{ $mset.Name }}.{{ $model.Name }}{},
	{{ end }}
	{{ end }}
	)

	return nil
}
