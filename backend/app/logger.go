package app

import (
	"os"

	"go.uber.org/zap"
)

var Logger *zap.Logger

func init() {
	if os.Getenv("APP_ENV") == "prod" {
		Logger, _ = zap.NewProduction()
	} else {
		Logger, _ = zap.NewDevelopment()
	}
	defer Logger.Sync()
}
