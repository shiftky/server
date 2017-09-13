package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/epy0n0ff/go-mackerel-webhook"
	"github.com/guregu/dynamo"
)

type AlertEvent struct {
	OrgName   string `dynamo:"OrgName" json:"orgName"`
	CreatedAt int64  `dynamo:"CreatedAt" json:"createdAt"`
	Status    string `dynamo:"Status" json:"status"`
	IsOpen    int    `dynamo:"IsOpen" json:"isOpen"`
	Title     string `dynamo:"Title" json:"title"`
	URL       string `dynamo:"Url" json:"Url"`
	Trigger   string `dynamo:"Trigger" json:"trigger"`
}

func NewAlertEvent(mackerel webhook.WebHook) *AlertEvent {
	var isOpen int
	if mackerel.Alert.IsOpen {
		isOpen = 1
	} else {
		isOpen = 0
	}

	return &AlertEvent{
		OrgName:   mackerel.OrgName,
		CreatedAt: mackerel.Alert.CreatedAt.Unix(),
		Status:    mackerel.Alert.Status,
		IsOpen:    isOpen,
		Title:     "alert", // TODO: generate alert title
		URL:       mackerel.Alert.URL,
		Trigger:   mackerel.Alert.Trigger,
	}
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
		var mackerel webhook.WebHook

		if err := json.Unmarshal(event, &mackerel); err != nil {
			return nil, err
		}

		evt := NewAlertEvent(mackerel)

		db := dynamo.New(session.New(), &aws.Config{
			Region: aws.String("ap-northeast-1"),
		})
		table := db.Table("Alert")

		if err := table.Put(evt).Run(); err != nil {
			return nil, err
		}

		return evt, nil
	})
}
