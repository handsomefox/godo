package task

import (
	"godo/app"
	"godo/app/response"
	"godo/db"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func GetTasks(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	user, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "User not found",
			Error:   true,
		})
	}

	tasks, err := db.GetUserTasks(user.ID)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "Tasks not found",
			Error:   true,
		})
	}

	return ctx.JSON(response.TaskResponse{
		Message: "Tasks found!",
		Error:   false,
		Tasks:   tasks,
	})
}

func CreateTask(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	user, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "User not found",
			Error:   true,
		})
	}

	task := new(db.Task)
	err = ctx.BodyParser(task)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "Invalid request body",
			Error:   true,
		})
	}

	task.User = user.ID
	err = db.InsertUserTask(task)
	if err != nil {
		return ctx.Status(http.StatusBadRequest).JSON(response.Error{
			Message: "Task creation failed",
			Error:   true,
		})
	}

	return ctx.Status(http.StatusOK).JSON(response.TaskResponse{
		Message: "Task created",
		Error:   false,
		Tasks:   []db.Task{*task},
	})
}

func UpdateTask(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	user, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "User not found",
			Error:   true,
		})
	}

	id := ctx.Params("id")
	if id == "" {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "Incorrect id",
			Error:   true,
		})
	}

	task := new(db.Task)
	err = ctx.BodyParser(task)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "Invalid request body",
			Error:   true,
		})
	}

	taskid, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		app.Logger.Sugar().Debug("error converting task id to hex")
		return err
	}
	task.ID = taskid
	task.User = user.ID
	err = db.UpdateUserTask(task)
	if err != nil {
		return ctx.Status(http.StatusBadRequest).JSON(response.Error{
			Message: "Task creation failed",
			Error:   true,
		})
	}

	return ctx.Status(http.StatusCreated).JSON(response.TaskResponse{
		Message: "Task updated",
		Error:   false,
		Tasks:   []db.Task{*task},
	})
}

func DeleteTask(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	_, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "User not found",
			Error:   true,
		})
	}

	id := ctx.Params("id")
	if id == "" {
		return ctx.Status(http.StatusNotFound).JSON(response.Error{
			Message: "Incorrect id",
			Error:   true,
		})
	}

	err = db.DeleteUserTask(id)
	if err != nil {
		return ctx.Status(http.StatusBadRequest).JSON(response.Error{
			Message: "Task deletion failed",
			Error:   true,
		})
	}

	return ctx.Status(http.StatusOK).JSON(response.TaskResponse{
		Message: "Task deleted",
		Error:   false,
		Tasks:   []db.Task{},
	})
}
