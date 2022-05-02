package util

import (
	"os"

	"go.uber.org/zap"
)

// Logger is the logger that should be used for everything in the application
//
// go.uber.org/zap for documentation
var Logger *zap.Logger

// init is used to configure the logger
func init() {
	if os.Getenv("APP_ENV") == "prod" {
		Logger, _ = zap.NewProduction()
	} else {
		Logger, _ = zap.NewDevelopment()
	}
}
