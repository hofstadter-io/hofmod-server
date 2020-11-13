package db

{{ $name := .SERVER.serverName }}

import (
  _ "github.com/jackc/pgx/v4/stdlib"
  "gorm.io/driver/postgres"
  "gorm.io/gorm"

	"{{ .ModuleImport }}/config"
)

func OpenPostgres() (err error) {

  dsn, err := config.Get("database.dsn")
  if err != nil {
    return err
  }

  dsnStr, err := dsn.String()
  if err != nil {
    return err
  }

  DB, err = gorm.Open(postgres.New(postgres.Config{
    DSN: dsnStr,
    PreferSimpleProtocol: true, // disables implicit prepared statement usage
	}), &gorm.Config{
		SkipDefaultTransaction: true,
		DisableForeignKeyConstraintWhenMigrating: true,
	})

  CommonSetup()

  if err != nil {
    return err
  }

  return nil
}
