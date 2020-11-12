package auth

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go/v4"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"golang.org/x/crypto/bcrypt"

	"{{ .ModuleImport }}/dm"
	"{{ .ModuleImport }}/mailer"
	"{{ .ModuleImport }}/server/config"
	"{{ .ModuleImport }}/server/db"
)

func AccountRegisterHandler(c echo.Context) (err error) {
	email := c.QueryParam("email")
	// TODO, validate email
	if email == "" {
		return c.String(http.StatusBadRequest, "invalid email address")
	}

	var user dm.User
	db.DB.Model(&dm.User{}).Where("email = ?", email).First(&user)

	if user.ID != uuid.Nil {
		return c.String(http.StatusBadRequest, "email already associated with an account")
	}

	p := c.QueryParam("password")
	// TODO, validate password
	if len(p) < 8 {
		return c.String(http.StatusBadRequest, "invalid password, must be at least 8 charactors long")
	}

	// encrypt the password
	P, err := bcrypt.GenerateFromPassword([]byte(p), BCRYPT_COST)
	if err != nil {
		c.Logger().Error(err)
		return err
	}

	// update the password
	err = db.DB.Create(&dm.User{
		Email: email,
		Password: string(P),
		Role: "user",
	}).Error

	if err != nil {
		c.Logger().Error(err)
		return err
	}

	err = sendConfirmEmail(email, c)
	if err != nil {
		return err
	}

	return c.String(http.StatusOK, "Please check your email and confirm your account")
}

func AccountResendConfirmHandler(c echo.Context) (err error) {
	email := c.QueryParam("email")
	// TODO, validate email
	if email == "" {
		return c.String(http.StatusBadRequest, "invalid email address")
	}

	var user dm.User
	db.DB.Model(&dm.User{}).Where("email = ?", email).First(&user)

	if user.ID != uuid.Nil {
		err = sendConfirmEmail(email, c)
		if err != nil {
			return err
		}
	}

	// Send the same message regardless if user exists or not
	return c.String(http.StatusOK, "Please check your email and confirm your account")
}

func AccountConfirmHandler(c echo.Context) (err error) {
	// get and check query params
	tokenString := c.QueryParam("token")
	if tokenString == "" {
		return c.String(http.StatusBadRequest, "missing token query param")
	}

	// parse the token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Don't forget to validate the alg is what you expect:
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}

		// return the secret for the jwt library
		secret, _ := config.Config.Lookup("secret").String()
		return []byte(secret), nil
	})

	// if the token is valid, try to update the password
	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		purpose := claims["purpose"].(string)
		if purpose != "confirm" {
			return c.String(http.StatusBadRequest, "invalid token")
		}

		// check the expiration time
		expStr := claims["expire"].(string)
		expire, err := time.Parse(time.RFC3339, expStr)
		if err != nil {
			c.Logger().Error(err)
			return err
		}
		if time.Now().After(expire) {
			return c.String(http.StatusBadRequest, "invalid token")
		}

		// activate the user
		email := claims["email"].(string)
		err = db.DB.Model(&dm.User{}).Where("email = ?", email).Update("active", true).Error
		if err != nil {
			c.Logger().Error(err)
			return err
		}

		sender := "Accounts Service - Example App <accounts@hofstadter.io>"
		subject := "Welcome to Hofstadter!"
		body := accountConfirmEmail
		recipient := email

		// The message object allows you to add attachments and Bcc recipients
		message := mailer.MG.NewMessage(sender, subject, body, recipient)

		// Send the message with a 10 second timeout
		ctx, cancel := context.WithTimeout(context.Background(), time.Second*10)
		defer cancel()
		resp, id, err := mailer.MG.Send(ctx, message)

		if err != nil {
				c.Logger().Error(err)
				return err
		}

		c.Logger().Debugf("Confirm Account ID: %s Resp: %s", id, resp)

		return c.String(http.StatusOK, "Account Confirmed")


	} else {
		c.Logger().Error(err)
		return err
	}

	return c.String(http.StatusBadRequest, "invalid token")
}

func sendConfirmEmail(email string, c echo.Context) (err error) {
	secret, _ := config.Config.Lookup("secret").String()

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"purpose": "confirm",
		"email": email,
		"expire": time.Now().Add(time.Hour * 24 * 3).Format(time.RFC3339),
	})

	tokenString, err := token.SignedString([]byte(secret))
	if err != nil {
		return err
	}

	sender := "Accounts Service - Example App <accounts@hofstadter.io>"
	subject := "Confirm Your Account"
	body := fmt.Sprintf(accountRegisterEmail, tokenString)
	recipient := email

	// The message object allows you to add attachments and Bcc recipients
	message := mailer.MG.NewMessage(sender, subject, body, recipient)

	// Send the message with a 10 second timeout
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*10)
	defer cancel()
	resp, id, err := mailer.MG.Send(ctx, message)

	if err != nil {
			c.Logger().Error(err)
			return err
	}

	c.Logger().Debugf("Confirm Account ID: %s Resp: %s", id, resp)

	return nil
}
