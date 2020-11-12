module github.com/hofstadter-io/hofmod-server

go 1.15

require (
	cuelang.org/go v0.2.1
	github.com/dgrijalva/jwt-go/v4 v4.0.0-preview1
	github.com/google/uuid v1.1.1
	github.com/hofstadter-io/hof v0.5.13
	github.com/hofstadter-io/yagu v0.0.3 // indirect
	github.com/jackc/pgx/v4 v4.9.0
	github.com/kirsle/configdir v0.0.0-20170128060238-e45d2f54772f
	github.com/kr/pretty v0.2.0
	github.com/labstack/echo v3.3.10+incompatible
	github.com/labstack/echo-contrib v0.9.0
	github.com/labstack/echo/v4 v4.1.17
	github.com/labstack/gommon v0.3.0
	github.com/parnurzeal/gorequest v0.2.16 // indirect
	github.com/prometheus/client_golang v1.1.0
	github.com/spf13/cobra v1.1.1
	golang.org/x/crypto v0.0.0-20200820211705-5c72a883971a
	gorm.io/driver/postgres v1.0.5
	gorm.io/gorm v1.20.6
	moul.io/http2curl v1.0.0 // indirect
)

replace cuelang.org/go => ../../../cue/cue

replace github.com/hofstadter-io/hof => ../../hof
