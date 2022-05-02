package db

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Task struct represents a todo app task
type Task struct {
	ID       primitive.ObjectID `bson:"_id" json:"id,"`
	Name     string             `bson:"name" json:"name,omitempty"`
	Desc     string             `bson:"desc" json:"desc"`
	Subtasks []string           `bson:"subtasks" json:"subtasks"`
	Due      time.Time          `bson:"due" json:"due"`
	User     primitive.ObjectID `bson:"user,omitempty" json:"user"`
}

// GetUserTasks returns a slice of all Tasks for the given user ID
func GetUserTasks(ID primitive.ObjectID) ([]Task, error) {
	tasks := TasksCollection()

	cursor, err := tasks.Find(context.TODO(), bson.M{userField: ID})
	if err != nil {
		log.Debug(err)
		return nil, ErrFindingTasks
	}

	userTasks := make([]Task, 0)
	cursor.All(context.TODO(), &userTasks)
	return userTasks, nil
}

// InsertTask inserts a task to the database
func InsertTask(task *Task) error {
	tasks := TasksCollection()

	task.ID = primitive.NewObjectID()
	_, err := tasks.InsertOne(context.TODO(), task)
	if err != nil {
		log.Debug(err)
		return ErrFindingTasks
	}

	return nil
}

// UpdateTask updates a task in the database
func UpdateTask(task *Task) error {
	tasks := TasksCollection()
	existingTask := new(Task)

	err := tasks.FindOne(context.TODO(), bson.M{idField: task.ID}).Decode(existingTask)
	if err != nil {
		log.Debug(err)
		return ErrFindingTasks
	}

	if task.Name != "" {
		existingTask.Name = task.Name
	}
	existingTask.Desc = task.Desc
	existingTask.Subtasks = task.Subtasks
	existingTask.Due = task.Due

	_, err = tasks.ReplaceOne(context.TODO(), bson.M{idField: task.ID}, existingTask)
	if err != nil {
		log.Debug(err)
		return ErrUpdatingTask
	}

	return nil
}

// DeleteTask remove task from the database for the given user ID
func DeleteTask(ID string) error {
	tasks := TasksCollection()

	id, err := primitive.ObjectIDFromHex(ID)
	if err != nil {
		log.Debug(err)
		return ErrInvalidID
	}

	res, err := tasks.DeleteOne(context.TODO(), bson.M{idField: id})
	if err != nil {
		log.Debug(err)
		return ErrDeletingTask
	}
	if res.DeletedCount == 0 {
		log.Debug(ErrNoTasksDeleted)
		return ErrNoTasksDeleted
	}

	return nil
}
