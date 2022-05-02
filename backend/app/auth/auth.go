package auth

import (
	"context"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"github.com/handsomefox/godo/backend/app"
	"github.com/handsomefox/godo/backend/app/response"
	"github.com/handsomefox/godo/backend/db"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"golang.org/x/crypto/bcrypt"
)

var log = app.Logger.Sugar()

func SignUp(ctx *fiber.Ctx) error {
	users := db.GetUserCol()
	user := new(db.User)
	err := ctx.BodyParser(user)
	if err != nil {
		return ctx.JSON(
			errWithMessage("Invalid signup data"),
		)
	}

	user.Password, err = hashPassword(user.Password)
	if err != nil {
		return ctx.JSON(
			errWithMessage("Invalid password"),
		)
	}

	result := users.FindOne(context.TODO(), bson.M{"email": user.Email})
	if result.Err() == nil {
		return ctx.JSON(
			errWithMessage("Email already exists"),
		)
	}

	user.ID = primitive.NewObjectID()
	_, err = users.InsertOne(context.TODO(), user)
	if err != nil {
		return ctx.JSON(
			errWithMessage("Error when creating user"),
		)
	}

	tokens, err := GetJWTToken(user.Email)
	if err != nil {
		return ctx.JSON(
			errWithMessage("Error when creating tokens"),
		)
	}

	return ctx.JSON(
		response.Success{
			Message: "User created successfully",
			Error:   false,
			Access:  tokens.Access,
			Refresh: tokens.Refresh,
		})
}

func CurrentUser(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	return ctx.JSON(
		fiber.Map{
			"user": claims.Issuer,
		},
	)
}

func Login(ctx *fiber.Ctx) error {
	users := db.GetUserCol()
	user := new(db.User)
	err := ctx.BodyParser(user)
	if err != nil {
		return ctx.JSON(
			errWithMessage("Invalid login data"),
		)
	}

	result := users.FindOne(context.TODO(), bson.M{"email": user.Email})
	if result.Err() != nil {
		return ctx.JSON(
			errWithMessage("Email does not exist. Please login."),
		)
	}

	userObj := new(db.User)
	result.Decode(&userObj)
	if !verifyPassword(user.Password, userObj.Password) {
		return ctx.JSON(
			errWithMessage("Invalid password"),
		)
	}

	tokens, err := GetJWTToken(user.Email)
	if err != nil {
		return ctx.JSON(
			errWithMessage("Error creating tokens"),
		)
	}

	return ctx.JSON(
		response.Success{
			Message: "Logged in succesfully",
			Error:   false,
			Access:  tokens.Access,
			Refresh: tokens.Refresh,
		},
	)
}

func hashPassword(pwd string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(pwd), 14)
	if err != nil {
		log.Debug("error hashing password", err)
		return "", err
	}

	return string(bytes), nil
}

func verifyPassword(pwd, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(pwd))
	return err == nil
}

func errWithMessage(msg string) response.Error {
	return response.Error{
		Message: msg,
		Error:   true,
	}
}
