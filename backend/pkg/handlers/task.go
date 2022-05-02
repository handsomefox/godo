package handlers

import (
	"godo/pkg/db"
	"net/http"

	"go.mongodb.org/mongo-driver/bson/primitive"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// GetTasks returns all the tasks for the given user from the database
//
// If the user is not found, ErrUserNotFound is returned.
// If fetching user tasks fails in some way, ErrTasksNotFound is returned.
// If user has not tasks, ErrNoTasks is returned.
func GetTasks(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	user, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(errResponseWithMsg(ErrUserNotFound.Error()))
	}

	tasks, err := db.GetUserTasks(user.ID)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(errResponseWithMsg(ErrTasksNotFound.Error()))
	}

	if len(tasks) == 0 {
		return ctx.Status(http.StatusOK).JSON(errResponseWithMsg(ErrNoTasks.Error()))
	}

	return ctx.Status(http.StatusOK).JSON(responseTasks{
		Message: taskFound,
		Error:   false,
		Tasks:   tasks,
	})
}

// Create tasks creates a task from request body and inserts it to the database
//
// If the user is not found, ErrUserNotFound and StatusNotFound is returned.
// If parsing the request body fails, ErrBadRequest StatusBadRequest is returned.
// If inserting the task to the database fails, ErrTaskCreation and StatusInternalServerError is returned.
func CreateTask(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	user, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(errResponseWithMsg(ErrUserNotFound.Error()))
	}

	task := new(db.Task)
	err = ctx.BodyParser(task)
	if err != nil {
		return ctx.Status(http.StatusBadRequest).JSON(errResponseWithMsg(ErrBadRequest.Error()))
	}

	task.User = user.ID
	err = db.InsertTask(task)
	if err != nil {
		return ctx.Status(http.StatusInternalServerError).JSON(errResponseWithMsg(ErrTaskCreation.Error()))
	}

	return ctx.Status(http.StatusOK).JSON(responseTasks{
		Message: taskCreated,
		Error:   false,
		Tasks:   []db.Task{*task},
	})
}

// UpdateTask finds and existing task in the database using ID, which is parsed from the request params
// and the updating task, which is parsed from the body updates an existing task in the database
//
// If the user is not found, ErrUserNotFound and StatusNotFound is returned.
// If parsing the ID from request parameters fails, ErrBadRequest and StatusBadRequest is returned.
// If parsing the request body fails, ErrBadRequest StatusBadRequest is returned.
// If updating the task in the database fails, ErrTaskCreation and StatusInternalServerError is returned.
func UpdateTask(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	user, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(errResponseWithMsg(ErrUserNotFound.Error()))
	}

	id := ctx.Params("id")
	if id == "" {
		return ctx.Status(http.StatusBadRequest).JSON(errResponseWithMsg(ErrBadRequest.Error()))
	}

	taskid, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		log.Debug(err)
		return ctx.Status(http.StatusBadRequest).JSON(errResponseWithMsg(ErrParseID.Error()))
	}

	task := new(db.Task)
	err = ctx.BodyParser(task)
	if err != nil {
		return ctx.Status(http.StatusBadGateway).JSON(errResponseWithMsg(ErrBadRequest.Error()))
	}

	task.ID = taskid
	task.User = user.ID
	err = db.UpdateTask(task)
	if err != nil {
		return ctx.Status(http.StatusInternalServerError).JSON(errResponseWithMsg(ErrTaskCreation.Error()))
	}

	return ctx.Status(http.StatusCreated).JSON(responseTasks{
		Message: taskUpdate,
		Error:   false,
		Tasks:   []db.Task{*task},
	})
}

// DeleteTask finds and existing task in the database using ID, which is parsed from the request params
// and tries to remove it from the database.
//
// If the user is not found, ErrUserNotFound and StatusNotFound is returned.
// If parsing the ID from request parameters fails, ErrBadRequest and StatusBadRequest is returned.
// If deleting the task from the database fails, ErrTaskCreation and StatusInternalServerError is returned.
func DeleteTask(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	_, err := db.GetCurrentUser(claims)
	if err != nil {
		return ctx.Status(http.StatusNotFound).JSON(errResponseWithMsg(ErrUserNotFound.Error()))
	}

	id := ctx.Params("id")
	if id == "" {
		return ctx.Status(http.StatusNotFound).JSON(errResponseWithMsg(ErrIncorrectID.Error()))
	}

	err = db.DeleteTask(id)
	if err != nil {
		return ctx.Status(http.StatusBadRequest).JSON(errResponseWithMsg(ErrTaskDeletion.Error()))
	}

	return ctx.Status(http.StatusOK).JSON(responseTasks{
		Message: taskDeleted,
		Error:   false,
		Tasks:   []db.Task{},
	})
}
