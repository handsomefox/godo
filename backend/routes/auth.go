package routes

import (
	"godo/app/auth"
	"godo/middleware"

	"github.com/gofiber/fiber/v2"
)

// /api/v1/auth
func Auth(baseRoute string, app *fiber.App) {
	// Sets the routes for auth
	app.Post(baseRoute+"/register", auth.SignUp)
	app.Post(baseRoute+"/login", auth.Login)
	app.Post(baseRoute+"/refresh", auth.RefreshToken)
	app.Get(baseRoute+"/curr-user", middleware.VerifyJwtWithClaim(auth.CurrentUser))
}
