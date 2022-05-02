package main

import (
	"godo/pkg/routes"
	"godo/pkg/util"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/joho/godotenv"
)

// Global logger
var log = util.Logger

// init is called before main()
// loads .env file or crashes
func init() {
	err := godotenv.Load()
	if err != nil {
		log.Sugar().Fatalf("failed to load .env file: %v", err)
	}
}

func main() {
	defer log.Sync()

	config := fiber.Config{
		Prefork:      true,
		ServerHeader: "go-todo-app",
		AppName:      "GoDO",
		Immutable:    true,
	}

	app := fiber.New(config)

	app.Use(cors.New(cors.Config{
		AllowCredentials: true,
	}))

	// Auth route
	routes.Auth("/api/v1/auth", app)

	// Tasks route
	routes.Task("api/v1/task", app)

	app.Listen(os.Getenv("HOST") + ":" + os.Getenv("PORT"))
}
