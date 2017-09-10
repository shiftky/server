package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/guregu/dynamo"
)

type Alerts struct {
	Alerts []Alert `json:"alerts"`
}

type Alert struct {
	Id        string `json:"id"`
	OrgName   string `json:"orgName"`
	Title     string `json:"title"`
	Status    string `json:"status"`
	IsOpen    int    `json:"isOpen"`
	Url       string `json:"url"`
	Trigger   string `json:"trigger"`
	CreatedAt int64  `json:"createdAt"`
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
		db := dynamo.New(session.New(), &aws.Config{
			Region: aws.String("ap-northeast-1"),
		})
		table := db.Table("Alert")

		var alerts []Alert

		if err := table.Get("OrgName", "Macker...").All(&alerts); err != nil {
			return nil, err
		}

		return Alerts{
			Alerts: alerts,
		}, nil
	})
}
