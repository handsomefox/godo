package middleware

import (
	"net/http"
	"os"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

var jwt_key = []byte(os.Getenv("JWT_SECRET_KEY"))

type AuthHeaders struct {
	Authorization string `reqHeader:"Authorization"`
}

func VerifyJwt(wrapper func(c *fiber.Ctx) error) func(c *fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		headers := new(AuthHeaders)
		err := c.ReqHeaderParser(headers)
		if err != nil {
			return c.Status(http.StatusUnauthorized).SendString("Unauthorized")
		}

		token := strings.Split(headers.Authorization, " ")

		if len(token) != 2 {
			return c.Status(http.StatusUnauthorized).SendString("Invalid Token Format.")
		}

		tkn, err := jwt.Parse(token[1], func(token *jwt.Token) (interface{}, error) {
			return jwt_key, nil
		})

		if err != nil || !tkn.Valid {
			return c.Status(http.StatusUnauthorized).SendString("Unauthorized")
		}

		return wrapper(c)
	}
}

func VerifyJwtWithClaim(wrapper func(c *fiber.Ctx, claims *jwt.RegisteredClaims) error) func(c *fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		headers := new(AuthHeaders)
		err := c.ReqHeaderParser(headers)
		if err != nil {
			return c.Status(http.StatusUnauthorized).SendString("Unauthorized")
		}

		claims := &jwt.RegisteredClaims{}
		token := strings.Split(headers.Authorization, " ")

		if len(token) != 2 {
			return c.Status(http.StatusUnauthorized).SendString("Invalid Token Format.")
		}

		tkn, err := jwt.ParseWithClaims(token[1], claims, func(token *jwt.Token) (interface{}, error) {
			return jwt_key, nil
		})
		if err != nil || !tkn.Valid {
			return c.Status(http.StatusUnauthorized).SendString("Unauthorized")
		}

		return wrapper(c, claims)
	}
}
