package server

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"strings"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/log"

	"{{ .ModuleImport }}/mailer"
	"{{ .ModuleImport }}/server/config"
	"{{ .ModuleImport }}/server/db"
)

func Run() {
	var err error

	_, err = config.Config.Lookup("secret").String()
	if err != nil {
		panic("app secret not set: " + err.Error())
	}

	err = mailer.InitMailgun()
	if err != nil {
		panic(err)
	}

	err = db.OpenPostgres()
	if err != nil {
		panic(err)
	}

	// create echo server
	e := echo.New()
	e.HideBanner = true

	err = setupLogging(e)
	if err != nil {
		panic(err)
	}

	// add middleware
	err = setupMiddleware(e)
	if err != nil {
		panic(err)
	}

	// setup router
	err = setupRouter(e)
	if err != nil {
		panic(err)
	}

	port, err := config.Get("port")
	if err != nil {
		panic(err)
	}
	portStr, err := port.String()
	if err != nil {
		panic(err)
	}
	portStr = ":" + portStr

	// Start server with background goroutine
	go func() {
		if err := e.Start(portStr); err != nil {
			e.Logger.Info("shutting down the server")
		}
	}()

	// Wait for interrupt signal to gracefully shutdown the server with
	// a timeout of 10 seconds.
	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)

	// wait on a quit signal
	<-quit

	// start the shutdown process
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()
	if err := e.Shutdown(ctx); err != nil {
		e.Logger.Fatal(err)
	}
}

func setupLogging(e *echo.Echo) error {
	loglvl, err := config.Get("logging.level")
	if err != nil && !strings.Contains(err.Error(), "not found") {
		return err
	}
	if loglvl.Exists() {
		lvlStr, err := loglvl.String()
		if err != nil {
			return err
		}

		lvl, ok := logLevels[lvlStr]
		if !ok {
			return fmt.Errorf("Unknown logging level: %q. shold be in {debug,info,warn,error,off}", lvlStr)
		}

		e.Logger.SetLevel(lvl)
	} else {
		// set logging level
		e.Logger.SetLevel(log.WARN)
	}


	format, err := config.Get("logging.format")
	if err != nil && !strings.Contains(err.Error(), "not found") {
		return err
	}
	if format.Exists() {
		fmtStr, err := format.String()
		if err != nil {
			return err
		}
		e.Logger.SetHeader(fmtStr)
	}

	return nil
}

var logLevels map[string]log.Lvl = map[string]log.Lvl {
	"debug": log.DEBUG,
	"info": log.INFO,
	"warn": log.WARN,
	"error": log.ERROR,
	"off": log.OFF,
}
