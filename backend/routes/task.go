package routes

import (
	"godo/app/task"
	"godo/middleware"

	"github.com/gofiber/fiber/v2"
)

// api/v1/task
func Task(baseRoute string, app *fiber.App) {
	app.Get(baseRoute+"/tasks", middleware.VerifyJwtWithClaim(task.GetTasks))
	app.Post(baseRoute+"/tasks", middleware.VerifyJwtWithClaim(task.CreateTask))
	app.Put(baseRoute+"/tasks/:id", middleware.VerifyJwtWithClaim(task.UpdateTask))
	app.Delete(baseRoute+"/tasks/:id", middleware.VerifyJwtWithClaim(task.DeleteTask))
}
