package handlers

import (
	"context"
	"godo/pkg/db"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"golang.org/x/crypto/bcrypt"
)

// SignUp handles the post request to /auth/register
func SignUp(ctx *fiber.Ctx) error {
	users := db.UsersCollection()
	user := new(db.User)

	err := ctx.BodyParser(user)
	if err != nil {
		log.Debug(err)
		return ctx.JSON(errResponseWithMsg(ErrInvalidSignUpData.Error()))
	}

	user.Password, err = hashPassword(user.Password)
	if err != nil {
		// log.Debug(err)
		return ctx.JSON(errResponseWithMsg(ErrInvalidPassword.Error()))
	}

	result := users.FindOne(context.TODO(), bson.M{"email": user.Email})
	if result.Err() == nil {
		log.Debug(result.Err())
		return ctx.JSON(errResponseWithMsg(ErrEmailExists.Error()))
	}

	user.ID = primitive.NewObjectID()
	_, err = users.InsertOne(context.TODO(), user)
	if err != nil {
		log.Debug(err)
		return ctx.JSON(errResponseWithMsg(ErrCreatingUser.Error()))
	}

	tokens, err := GetJWTToken(user.Email)
	if err != nil {
		log.Debug(err)
		return ctx.JSON(errResponseWithMsg(ErrCreatingTokens.Error()))
	}

	return ctx.JSON(
		responseSuccess{
			Message: userCreated,
			Error:   false,
			Access:  tokens.Access,
			Refresh: tokens.Refresh,
		})
}

// CurrentUser handles /auth/curr-user path and returns the JSON with current user email.
func CurrentUser(ctx *fiber.Ctx, claims *jwt.RegisteredClaims) error {
	return ctx.JSON(
		fiber.Map{
			"user": claims.Issuer,
		},
	)
}

// Login handles /auth/login path and handles all login procedure
func Login(ctx *fiber.Ctx) error {
	users := db.UsersCollection()
	user := new(db.User)

	err := ctx.BodyParser(user)
	if err != nil {
		log.Debug(err)
		return ctx.JSON(errResponseWithMsg(ErrInvalidLoginData.Error()))
	}

	result := users.FindOne(context.TODO(), bson.M{"email": user.Email})
	if result.Err() != nil {
		log.Debug(result.Err())
		return ctx.JSON(errResponseWithMsg(ErrUserDoesNotExist.Error()))
	}

	userObj := new(db.User)
	result.Decode(&userObj)
	if !verifyPassword(user.Password, userObj.Password) {
		return ctx.JSON(errResponseWithMsg(ErrInvalidPassword.Error()))
	}

	tokens, err := GetJWTToken(user.Email)
	if err != nil {
		log.Debug(err)
		return ctx.JSON(
			errResponseWithMsg(ErrCreatingTokens.Error()),
		)
	}

	return ctx.JSON(
		responseSuccess{
			Message: loginSuccess,
			Error:   false,
			Access:  tokens.Access,
			Refresh: tokens.Refresh,
		},
	)
}

// hashPassword hashes a password string using bcrypt package.
//
// If it fails, it returns and ErrHashingPwd
// Otherwise, returns the hashed password.
func hashPassword(pwd string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(pwd), 14)
	if err != nil {
		log.Debug(err)
		return "", ErrHashingPwd
	}

	return string(bytes), nil
}

// verifyPassword uses bcrypt package to compare hash and password and returns true on success, or false on error.
func verifyPassword(pwd, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(pwd))
	return err == nil
}
