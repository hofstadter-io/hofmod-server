package db

import (
  "time"
	"database/sql"

  "gorm.io/gorm"
)

var DB *gorm.DB
var sqlDB *sql.DB

func CommonSetup() (err error) {
	// SetMaxIdleConns sets the maximum number of connections in the idle connection pool.
	sqlDB.SetMaxIdleConns(10)

	// SetMaxOpenConns sets the maximum number of open connections to the database.
	sqlDB.SetMaxOpenConns(100)

	// SetConnMaxLifetime sets the maximum amount of time a connection may be reused.
	sqlDB.SetConnMaxLifetime(time.Hour)

  return nil
}
