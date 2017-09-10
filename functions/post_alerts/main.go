package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/guregu/dynamo"
)

type MackerelWebhook struct {
	Alert struct {
		CreatedAt         int64   `json:"createdAt"`
		CriticalThreshold float64 `json:"criticalThreshold"`
		Duration          int     `json:"duration"`
		IsOpen            bool    `json:"isOpen"`
		MetricLabel       string  `json:"metricLabel"`
		MetricValue       float64 `json:"metricValue"`
		MonitorName       string  `json:"monitorName"`
		MonitorOperator   string  `json:"monitorOperator"`
		Status            string  `json:"status"`
		Trigger           string  `json:"trigger"`
		URL               string  `json:"url"`
		WarningThreshold  float64 `json:"warningThreshold"`
	} `json:"alert"`
	Event string `json:"event"`
	Host  struct {
		ID        string `json:"id"`
		IsRetired bool   `json:"isRetired"`
		Memo      string `json:"memo"`
		Name      string `json:"name"`
		Roles     []struct {
			Fullname    string `json:"fullname"`
			RoleName    string `json:"roleName"`
			RoleURL     string `json:"roleUrl"`
			ServiceName string `json:"serviceName"`
			ServiceURL  string `json:"serviceUrl"`
		} `json:"roles"`
		Status string `json:"status"`
		URL    string `json:"url"`
	} `json:"host"`
	OrgName string `json:"orgName"`
}

type AlertEvent struct {
	OrgName   string `dynamo:"OrgName" json:"orgName"`
	CreatedAt int64  `dynamo:"CreatedAt" json:"createdAt"`
	AlertID   string `dynamo:"AlertId" json:"alertId"`
	Status    string `dynamo:"Status" json:"status"`
	IsOpen    int    `dynamo:"IsOpen" json:"isOpen"`
	Title     string `dynamo:"Title" json:"title"`
	AlertURL  string `dynamo:"AlertUrl" json:"alertUrl"`
	Trigger   string `dynamo:"Trigger" json:"trigger"`
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
		var mackerel MackerelWebhook

		if err := json.Unmarshal(event, &mackerel); err != nil {
			return nil, err
		}

		db := dynamo.New(session.New(), &aws.Config{
			Region: aws.String("ap-northeast-1"),
		})
		table := db.Table("Alert")

		var isOpen int
		if mackerel.Alert.IsOpen {
			isOpen = 1
		} else {
			isOpen = 0
		}

		evt := AlertEvent{
			OrgName:   mackerel.OrgName,
			CreatedAt: mackerel.Alert.CreatedAt,
			AlertID:   "hogehoge123",
			Status:    mackerel.Alert.Status,
			IsOpen:    isOpen,
			Title:     "hogehoge alert",
			AlertURL:  mackerel.Alert.URL,
			Trigger:   mackerel.Alert.Trigger,
		}

		if err := table.Put(evt).Run(); err != nil {
			return nil, err
		}

		return evt, nil
	})
}
