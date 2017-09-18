package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/guregu/dynamo"
)

type User struct {
	CognitoId       string `dynamo:"CognitoId" json:"cognitoId"`
	Name            string `dynamo:"Name" json:"name"`
	Email           string `dynamo:"Email" json:"email"`
	TelephoneNumber string `dynamo:"TelephoneNumber" json:"telephoneNumber"`
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
		var user User

		if err := json.Unmarshal(event, &user); err != nil {
			return nil, err
		}

		db := dynamo.New(session.New(), &aws.Config{
			Region: aws.String("ap-northeast-1"),
		})
		table := db.Table("User")

		if err := table.Put(user).Run(); err != nil {
			return nil, err
		}

		return user, nil
	})
}
