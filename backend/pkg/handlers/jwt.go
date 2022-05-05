package handlers

import (
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

var (
	// accessExpiration is the expiration time for access token
	accessExpiration = jwt.NewNumericDate(time.Now().Add(time.Hour * 24))
	// refreshExpiration is the expiration time for refresh token
	refreshExpiration = jwt.NewNumericDate(time.Now().Add(time.Hour * 240))
	// secret is a byte array from the environment
	secret = []byte(os.Getenv("JWT_SECRET_KEY"))
)

// Tokens contains access and refresh tokens
type Tokens struct {
	Access  string `json:"refresh_token"`
	Refresh string `json:"access_token"`
}

// AuthHeader is used for parsing Authorization header from context
type AuthHeader struct {
	Authorization string `reqHeader:"Authorization"`
}

func VerifyJwtWithClaim(wrapper func(c *fiber.Ctx, claims *jwt.RegisteredClaims) error) func(c *fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		headers := new(AuthHeader)
		err := c.ReqHeaderParser(headers)
		if err != nil {
			return c.Status(http.StatusUnauthorized).SendString(ErrUnauthorized.Error())
		}

		claims := &jwt.RegisteredClaims{}
		token := strings.Split(headers.Authorization, " ")

		if len(token) != 2 {
			return c.Status(http.StatusUnauthorized).SendString(ErrInvalidTokenFmt.Error())
		}

		tkn, err := jwt.ParseWithClaims(token[1], claims, func(token *jwt.Token) (interface{}, error) {
			return secret, nil
		})
		if err != nil || !tkn.Valid {
			return c.Status(http.StatusUnauthorized).SendString(ErrUnauthorized.Error())
		}

		return wrapper(c, claims)
	}
}

func GetJWTToken(user string) (*Tokens, error) {
	claims := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.RegisteredClaims{
		Issuer:    user,
		ExpiresAt: accessExpiration,
	})

	claims2 := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.RegisteredClaims{
		Issuer:    user,
		Subject:   "Refresh",
		ExpiresAt: refreshExpiration,
	})

	token, err := claims.SignedString([]byte(secret))
	if err != nil {
		return nil, err
	}

	reftoken, err := claims2.SignedString([]byte(secret))
	if err != nil {
		return nil, err
	}

	tokens := &Tokens{
		Access:  token,
		Refresh: reftoken,
	}

	return tokens, nil
}

func RefreshToken(ctx *fiber.Ctx) error {
	tokens := new(Tokens)
	claims := &jwt.RegisteredClaims{}

	err := ctx.BodyParser(tokens)
	if err != nil {
		return ctx.JSON(errResponseWithMsg(err.Error()))
	}

	_, err = jwt.ParseWithClaims(tokens.Refresh, claims, func(token *jwt.Token) (interface{}, error) {
		return secret, nil
	})

	if err != nil {
		return ctx.JSON(errResponseWithMsg(err.Error()))
	}

	if claims.Subject != "Refresh" {
		return ctx.JSON(errResponseWithMsg(ErrInvalidToken.Error()))
	}

	token, err := GetJWTToken(claims.Issuer)
	if err != nil {
		log.Debug(err)
		return ctx.JSON(errResponseWithMsg(ErrCreatingTokens.Error()))
	}

	return ctx.JSON(token)
}
