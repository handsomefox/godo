package db

import (
	"context"
	"os"
	"time"

	"godo/app"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func GetDB() *mongo.Database {
	serverAPIOptions := options.ServerAPI(options.ServerAPIVersion1)
	clientOptions := options.Client().ApplyURI(os.Getenv("MONGO_URI")).SetServerAPIOptions(serverAPIOptions)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, clientOptions)

	if err != nil {
		tries := 1

		for err == nil {
			app.Logger.Sugar().Error("error connecting to database", err, "retrying, try #", tries)
			client, err = mongo.Connect(ctx, clientOptions)
			tries++
		}
	}

	if err != nil {
		app.Logger.Sugar().Panic("couldn't connect to the database, panicking", err)
	}

	return client.Database("godo_app")
}

func GetUserCol() *mongo.Collection {
	return GetDB().Collection("users")
}

func GetTasksCol() *mongo.Collection {
	return GetDB().Collection("tasks")
}
