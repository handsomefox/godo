package db

import (
	"errors"
	"godo/pkg/util"
)

// Errors returned by db package
var (
	ErrConnectionFailed = errors.New("couldn't connect to the database, panicking")
	ErrFindingTasks     = errors.New("error searching for users tasks")
	ErrInsertingTask    = errors.New("error inserting task")
	ErrUpdatingTask     = errors.New("error updating task")
	ErrInvalidID        = errors.New("error converting task id to hex")
	ErrNoTasksDeleted   = errors.New("did not delete any tasks")
	ErrDeletingTask     = errors.New("error deleting task")
	ErrUserNotFound     = errors.New("user not found in the database")
)

// Logger used by db package
var (
	log = util.Logger.Sugar()
)
