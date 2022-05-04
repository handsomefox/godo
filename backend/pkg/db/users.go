package db

import (
	"context"

	"github.com/golang-jwt/jwt/v4"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Bson field names for struct
const (
	idField    = "_id"
	userField  = "user"
	emailField = "email"
	pwdField   = "password"
	nameField  = "name"
)

// User struct represents a registered user
type User struct {
	ID       primitive.ObjectID `bson:"_id"`
	Name     string             `bson:"name,omitempty"`
	Email    string             `bson:"email,omitempty"`
	Password string             `bson:"password,omitempty"`
}

// GetUserByID returns a pointer to a User struct if the user exists, or ErrUserNotFound if the user does not exist
func GetUserByID(id primitive.ObjectID) (*User, error) {
	users := UsersCollection()
	user := User{}

	err := users.FindOne(context.TODO(), bson.M{idField: id}).Decode(&user)
	if err != nil {
		log.Debug(err)
		return nil, ErrUserNotFound
	}

	return &user, nil
}

// GetCurrentUser returns a pointer to a User struct if the user exists and is logged in
// or ErrUserNotFound if the user does not exist
func GetCurrentUser(claims *jwt.RegisteredClaims) (*User, error) {
	users := UsersCollection()
	user := User{}

	err := users.FindOne(context.TODO(), bson.M{emailField: claims.Issuer}).Decode(&user)
	if err != nil {
		log.Debug(err)
		return nil, ErrUserNotFound
	}

	return &user, nil
}
