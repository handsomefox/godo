package main

import (
	"godo/app"
	"godo/routes"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/joho/godotenv"
)

func init() {
	err := godotenv.Load()
	if err != nil {
		app.Logger.Sugar().Infow("failed to load .env file",
			"error", err)
	}
}

func main() {
	app := fiber.New(fiber.Config{
		Prefork:      true,
		ServerHeader: "go-todo-app",
		AppName:      "GoDO",
		Immutable:    true,
	})

	app.Use(cors.New(cors.Config{
		AllowCredentials: true,
	}))

	// Auth route
	routes.Auth("/api/v1/auth", app)

	// Tasks route
	routes.Task("api/v1/task", app)

	app.Listen(os.Getenv("HOST") + ":" + os.Getenv("PORT"))
}
