// db package is used for operating with a mongodb database
package db

import (
	"context"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Context timeout
var timeout = 10 * time.Second

// Database parameters
const (
	mongoEnv       = "MONGO_URI" // env variable name
	userCollection = "users"
	taskCollection = "tasks"
	databaseName   = "godo_app"
)

// Connects to the mongo database and returns it. If connection fails the function panics (will be fixed).
func GetDatabase() *mongo.Database {
	serverAPIOptions := options.ServerAPI(options.ServerAPIVersion1)
	clientOptions := options.Client().ApplyURI(os.Getenv(mongoEnv)).SetServerAPIOptions(serverAPIOptions)

	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		// We shouldn't panic, but return an error instead.
		log.Panic(ErrConnectionFailed, err)
	}

	return client.Database(databaseName)
}

// UsersCollection returns a pointer to mongo.Collection struct for the Users collection in the database
func UsersCollection() *mongo.Collection {
	return GetDatabase().Collection(userCollection)
}

// TasksCollection returns a pointer to mongo.Collection struct for the Tasks collection in the database
func TasksCollection() *mongo.Collection {
	return GetDatabase().Collection(taskCollection)
}
