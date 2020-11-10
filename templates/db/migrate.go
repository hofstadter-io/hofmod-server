package db

{{ $ModuleImport := .ModuleImport }}

import (
	"{{ $ModuleImport }}/dm"
)


func RunMigrations() (err error) {
	DB.AutoMigrate(
	// Builtin Models
	{{ range $i, $model := .MODELS.Builtin.MigrateOrder -}}
		&dm.{{ $model.ModelName }}{},
	{{ end }}

	// User Models
	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	{{ $MODELS := $mset.Models -}}
	{{ if $mset.MigrateOrder }}{{ $MODELS = $mset.MigrateOrder }}{{ end -}}
	{{ range $j, $model := $MODELS -}}
		&dm.{{ $model.ModelName }}{},
	{{ end }}
	{{ end }}
	)

	return nil
}
