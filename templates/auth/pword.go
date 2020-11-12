package auth

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go/v4"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"

	"{{ .ModuleImport }}/dm"
	"{{ .ModuleImport }}/mailer"
	"{{ .ModuleImport }}/server/config"
	"{{ .ModuleImport }}/server/db"
)

const BCRYPT_COST = 12

func passwordMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {

		// already auth'd?
		if c.Get("user") != nil {
			return next(c)
		}

		email, password, ok := c.Request().BasicAuth()
		if !ok {
			return next(c)
		}

		// lookup user
		user := &dm.User{}
		err := db.DB.Table("users").Where("email = ?", email).First(user).Error
		if err != nil {
			c.Logger().Error(err)
			if !errors.Is(err, gorm.ErrRecordNotFound) {
				c.Logger().Error(err)
			}
			return next(c)
		}
		if user == nil || user.ID == uuid.Nil {
			c.Logger().Error("nil user")
			return next(c)
		}

		// check password value
		err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
		// some password error, don't actually return the error
		if err != nil {
			return next(c)
		}

		// user auth'd
		c.Set("user", user)

		return next(c)
	}
}

func passwordRoutes(G *echo.Group) {
	g := G.Group("/password")
	g.GET("/reset-request", passwordResetRequest)
	g.GET("/reset", passwordResetDoReset)
}

func passwordResetRequest(c echo.Context) (err error) {

	email := c.QueryParam("email")
	var user dm.User
	db.DB.Model(&dm.User{}).Where("email = ?", email).First(&user)

	// if we found a user, generate a token and email
	if user.ID != uuid.Nil {
		// this should definitely already be valid
		secret, _ := config.Config.Lookup("secret").String()

		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"email": email,
			"expire": time.Now().Add(time.Hour * 24).Format(time.RFC3339),
		})

		tokenString, err := token.SignedString([]byte(secret))
		if err != nil {
			return err
		}

		sender := "Accounts Service - Example App <accounts@hofstadter.io>"
    subject := "Password Reset Request"
		body := fmt.Sprintf(passwordResetEmail, tokenString)
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

    c.Logger().Debugf("ID: %s Resp: %s", id, resp)
	}

	// we want to return the same message regardless if the email exists or not
	return c.String(http.StatusOK, "Check your email for the reset link, replace PASSWORD with your desired password")
}

func passwordResetDoReset(c echo.Context) (err error) {

	// get and check query params
	tokenString := c.QueryParam("token")
	if tokenString == "" {
		return c.String(http.StatusBadRequest, "missing token query param")
	}

	p := c.QueryParam("password")
	if p == "" {
		return c.String(http.StatusBadRequest, "missing password query param")
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

		// check the expiration time
		expStr := claims["expire"].(string)
		expire, err := time.Parse(time.RFC3339, expStr)
		if err != nil {
			c.Logger().Error(err)
			return err
		}
		if time.Now().After(expire) {
			return c.String(http.StatusBadRequest, "reset token has expired")
		}

		// encrypt the password
		P, err := bcrypt.GenerateFromPassword([]byte(p), BCRYPT_COST)
		if err != nil {
			c.Logger().Error(err)
			return err
		}

		// update the password
		err = db.DB.Model(&dm.User{}).Where("email = ?", claims["email"]).Update("password", string(P)).Error
		if err != nil {
			c.Logger().Error(err)
			return err
		}

	} else {
		c.Logger().Error(err)
		return err
	}

	return c.String(http.StatusOK, "Password Reset")
}

const passwordResetEmail = `Hello from hofmod-server Example App!

Paste the following link in your browser and <b>ADD A PASSWORD</b> to the end.

http://localhost:1323/auth/password/reset?token=%s&password=
`
