package db

import (
	"context"
	"errors"
	"time"

	"godo/app"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

var (
	ErrNoTasksDeleted = errors.New("did not delete any tasks")
)

var log = app.Logger.Sugar()

type Task struct {
	ID       primitive.ObjectID `bson:"_id" json:"id,"`
	Name     string             `bson:"name" json:"name,omitempty"`
	Desc     string             `bson:"desc" json:"desc"`
	Subtasks []string           `bson:"subtasks" json:"subtasks"`
	Due      time.Time          `bson:"due" json:"due"`
	User     primitive.ObjectID `bson:"user,omitempty" json:"user"`
}

func GetUserTasks(ID primitive.ObjectID) ([]Task, error) {
	tasks := GetTasksCol()

	filter := bson.M{"user": ID}
	cursor, err := tasks.Find(context.TODO(), filter)
	if err != nil {
		log.Info("error searching for users tasks", err)
		return nil, err
	}

	userTasks := make([]Task, 0)
	cursor.All(context.TODO(), &userTasks)

	return userTasks, nil
}

func InsertUserTask(task *Task) error {
	task.ID = primitive.NewObjectID()
	tasks := GetTasksCol()

	_, err := tasks.InsertOne(context.TODO(), task)
	if err != nil {
		log.Debug("error inserting task", err)
		return err
	}

	return nil
}

func UpdateUserTask(task *Task) error {
	tasks := GetTasksCol()

	existingTask := new(Task)
	err := tasks.FindOne(context.TODO(), bson.M{"_id": task.ID}).Decode(existingTask)
	if err != nil {
		log.Debug("error finding task", err)
		return err
	}

	if task.Name != "" {
		existingTask.Name = task.Name
	}
	existingTask.Desc = task.Desc
	existingTask.Subtasks = task.Subtasks
	existingTask.Due = task.Due

	_, err = tasks.ReplaceOne(context.TODO(), bson.M{"_id": task.ID}, existingTask)
	if err != nil {
		log.Debug("error update task", err)
		return err
	}

	return nil
}

func DeleteUserTask(ID string) error {
	tasks := GetTasksCol()

	id, err := primitive.ObjectIDFromHex(ID)
	if err != nil {
		log.Debug("error converting task id to hex")
		return err
	}
	res, err := tasks.DeleteOne(context.TODO(), bson.M{"_id": id})
	if err != nil {
		log.Debug("error deleting task", err)
		return err
	}

	if res.DeletedCount == 0 {
		return ErrNoTasksDeleted
	}

	return nil
}
