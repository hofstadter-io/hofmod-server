package main

import (
	// "fmt"
	"net/http"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
)

type (
	User struct {
		Name  string `json:"name" validate:"required"`
		Email string `json:"email" validate:"required,email"`
	}

	CustomValidator struct {
		validator *validator.Validate
	}
)

func (cv *CustomValidator) Validate(i interface{}) error {
	return cv.validator.Struct(i)
}

func main() {
	e := echo.New()
	e.Validator = &CustomValidator{validator: validator.New()}
	e.POST("/users", func(c echo.Context) (err error) {
		u := new(User)
		if err = c.Bind(u); err != nil {
			return
		}
		if err = c.Validate(u); err != nil {
			return c.String(http.StatusBadRequest, err.Error())
		}
		return c.JSON(http.StatusOK, u)
	})
	e.Logger.Fatal(e.Start(":1323"))
}
