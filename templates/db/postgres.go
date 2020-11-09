package db

{{ $name := .SERVER.serverName }}

import (
  "database/sql"

  _ "github.com/jackc/pgx/v4/stdlib"
  "gorm.io/driver/postgres"
  "gorm.io/gorm"
)

func OpenPostgres() (err error) {

  dsn := "host=localhost user={{ $name }} password={{ $name }} dbname={{ $name }} port=5432 sslmode=disable TimeZone=UTC"

  sqlDB, err = sql.Open("pgx", dsn)
  if err != nil {
    return err
  }

  CommonSetup()

  DB, err = gorm.Open(postgres.New(postgres.Config{
    Conn: sqlDB,
    PreferSimpleProtocol: true, // disables implicit prepared statement usage
  }), &gorm.Config{})

  if err != nil {
    return err
  }

  return nil
}