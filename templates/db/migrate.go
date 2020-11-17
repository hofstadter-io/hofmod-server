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

		// Custom Models
	{{ range $i, $model := .MODELS.Custom.MigrateOrder -}}
		&dm.{{ $model.ModelName }}{},
	{{ end }}
	)

	return nil
}
