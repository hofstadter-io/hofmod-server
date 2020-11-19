package db

{{ $name := .SERVER.serverName }}

import (
	"log"
	"os"
	"time"

  _ "github.com/jackc/pgx/v4/stdlib"
  "gorm.io/driver/postgres"
  "gorm.io/gorm"
  "gorm.io/gorm/logger"

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

	newLogger := logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags), // io writer
		logger.Config{
			SlowThreshold: time.Millisecond * 100,   // Slow SQL threshold
			LogLevel:      logger.Warn,   // Log level
			Colorful:      true,         // Disable color
		},
	)

  DB, err = gorm.Open(postgres.New(postgres.Config{
    DSN: dsnStr,
    PreferSimpleProtocol: true, // disables implicit prepared statement usage
	}), &gorm.Config{
		Logger: newLogger,
		SkipDefaultTransaction: true,
		DisableForeignKeyConstraintWhenMigrating: true,
	})

  CommonSetup()

  if err != nil {
    return err
  }

  return nil
}
