package routes

import (
	"godo/pkg/handlers"

	"github.com/gofiber/fiber/v2"
)

// Auth sets the routes for auth
//
// base route: /api/v1/auth
func Auth(baseRoute string, app *fiber.App) {
	app.Post(baseRoute+"/register", handlers.SignUp)
	app.Post(baseRoute+"/login", handlers.Login)
	app.Post(baseRoute+"/refresh", handlers.RefreshToken)
	app.Get(baseRoute+"/curr-user", handlers.VerifyJwtWithClaim(handlers.CurrentUser))
}
