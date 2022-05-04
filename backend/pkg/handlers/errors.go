package handlers

import (
	"errors"

	"godo/pkg/util"
)

// errors used by the handlers package
var (
	ErrUserNotFound  = errors.New("user not found")
	ErrTasksNotFound = errors.New("tasks not found")
	ErrNoTasks       = errors.New("user has not tasks")
	ErrTaskCreation  = errors.New("failed to create task")
	ErrTaskDeletion  = errors.New("task deletion failed")
	ErrBadRequest    = errors.New("invalid request body")
	ErrParseID       = errors.New("error converting task id to hex")
	ErrIncorrectID   = errors.New("incorrect id")

	// auth errors
	ErrInvalidSignUpData = errors.New("invalid signup data")
	ErrInvalidLoginData  = errors.New("invalid login data")
	ErrInvalidPassword   = errors.New("invalid password")
	ErrInvalidToken      = errors.New("invalid token")
	ErrInvalidTokenFmt   = errors.New("invalid token format")
	ErrUserDoesNotExist  = errors.New("user is not signed up")
	ErrEmailExists       = errors.New("email already exists")
	ErrUsernameTaken     = errors.New("user name is already taken")
	ErrCreatingUser      = errors.New("error when creating user")
	ErrCreatingTokens    = errors.New("error when creating tokens")
	ErrHashingPwd        = errors.New("error hashing password")
	ErrUnauthorized      = errors.New("unauthorized")
)

// Response messages used by the handlers package
const (
	taskUpdate  = "Task updated"
	taskFound   = "Tasks found!"
	taskCreated = "Task created"
	taskDeleted = "Task deleted"

	// auth messages
	userCreated  = "User created successfully"
	loginSuccess = "Logged in succesfully"
)

// logger used by the handlers package
var (
	log = util.Logger.Sugar()
)
