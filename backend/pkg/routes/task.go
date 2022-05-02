package routes

import (
	"godo/pkg/handlers"

	"github.com/gofiber/fiber/v2"
)

// Task sets the routes for tasks
//
// base route : api/v1/task
func Task(baseRoute string, app *fiber.App) {
	app.Get(baseRoute+"/tasks", handlers.VerifyJwtWithClaim(handlers.GetTasks))
	app.Post(baseRoute+"/tasks", handlers.VerifyJwtWithClaim(handlers.CreateTask))
	app.Put(baseRoute+"/tasks/:id", handlers.VerifyJwtWithClaim(handlers.UpdateTask))
	app.Delete(baseRoute+"/tasks/:id", handlers.VerifyJwtWithClaim(handlers.DeleteTask))
}
