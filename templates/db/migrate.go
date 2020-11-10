package db

{{ $ModuleImport := .ModuleImport }}

import (
	"{{ $ModuleImport }}/dm/Builtin"
	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	"{{ $ModuleImport }}/dm/{{ $mset.Name }}"
	{{ end }}
)


func RunMigrations() (err error) {
	DB.AutoMigrate(
	// Builtin Models
	{{ range $i, $model := .MODELS.Builtin.MigrateOrder -}}
		&Builtin.{{ $model.Name }}{},
	{{ end }}

	// User Models
	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	{{ $MODELS := $mset.Models -}}
	{{ if $mset.MigrateOrder }}{{ $MODELS = $mset.MigrateOrder }}{{ end -}}
	{{ range $j, $model := $MODELS -}}
		&{{ $mset.Name }}.{{ $model.Name }}{},
	{{ end }}
	{{ end }}
	)

	return nil
}
