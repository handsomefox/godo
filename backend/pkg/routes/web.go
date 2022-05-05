package routes

import (
	"github.com/gofiber/fiber/v2"
)

// Web hosts the web app
//
// base route : /
func Web(baseRoute string, app *fiber.App) {
	app.Static(baseRoute, "/web")
}
