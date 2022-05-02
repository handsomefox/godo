package db

import (
	"context"

	"github.com/golang-jwt/jwt/v4"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID       primitive.ObjectID `bson:"_id"`
	Name     string             `bson:"name,omitempty"`
	Email    string             `bson:"email,omitempty"`
	Password string             `bson:"password,omitempty"`
}

func GetUserByID(id primitive.ObjectID) (*User, error) {
	users := GetUserCol()
	var user User
	err := users.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&user)
	return &user, err
}

func GetCurrentUser(claims *jwt.RegisteredClaims) (*User, error) {
	users := GetUserCol()
	email := claims.Issuer
	var user User
	err := users.FindOne(context.TODO(), bson.M{"email": email}).Decode(&user)
	return &user, err
}
