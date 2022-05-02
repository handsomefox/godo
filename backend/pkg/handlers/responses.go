package handlers

import "godo/pkg/db"

// responseTasks is used when responding to requests that require Tasks to be returned.
// It is marshalled to JSON and sent back.
type responseTasks struct {
	Message string    `json:"message"`
	Error   bool      `json:"error"`
	Tasks   []db.Task `json:"tasks,omitempty"`
}

// responseError is used when responding to requests that have failed.
// It is marshalled to JSON and sent back.
type responseError struct {
	Message string `json:"message"`
	Error   bool   `json:"error" default:"true"`
}

// errResponseWithMsg is used to create a responseError struct with `Error=true` and the given message
func errResponseWithMsg(msg string) responseError {
	return responseError{
		Message: msg,
		Error:   true,
	}
}

// responseTasks is used when responding to registration requests that have succeeded.
// It is marshalled to JSON and sent back.
type responseSuccess struct {
	Message string `json:"message"`
	Error   bool   `json:"error" default:"false"`
	Access  string `json:"access_token"`
	Refresh string `json:"refresh_token"`
}
