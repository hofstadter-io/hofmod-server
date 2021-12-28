module github.com/hofstadter-io/hofmod-server

go 1.15

require (
	cuelang.org/go v0.4.0
	github.com/dgrijalva/jwt-go/v4 v4.0.0-preview1
	github.com/go-playground/validator/v10 v10.4.1
	github.com/google/uuid v1.2.0
	github.com/hofstadter-io/hof v0.6.0
	github.com/jackc/pgx/v4 v4.9.0
	github.com/kirsle/configdir v0.0.0-20170128060238-e45d2f54772f
	github.com/labstack/echo-contrib v0.9.0
	github.com/labstack/echo/v4 v4.1.17
	github.com/labstack/gommon v0.3.0
	github.com/lane-c-wagner/go-password-validator v0.1.0
	github.com/mailgun/mailgun-go/v4 v4.3.0
	github.com/parnurzeal/gorequest v0.2.16
	github.com/prometheus/client_golang v1.1.0
	github.com/spf13/cobra v1.1.1
	golang.org/x/crypto v0.0.0-20200820211705-5c72a883971a
	gorm.io/driver/postgres v1.0.5
	gorm.io/gorm v1.20.6
)

replace cuelang.org/go => ../../../cue/cue
