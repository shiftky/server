package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
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

type Response struct {
	AlertID   string `json:"alertId"`
	IsOpen    bool   `json:"isOpen"`
	Title     string `json:"title"`
	Status    string `json:"status"`
	AlertURL  string `json:"alertUrl"`
	Trigger   string `json:"trigger"`
	CreatedAt int64  `json:"createdAt"`
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
		var mackerel MackerelWebhook

		if err := json.Unmarshal(event, &mackerel); err != nil {
			return nil, err
		}

		response := Response{
			AlertID:   "hogehoge123",
			IsOpen:    mackerel.Alert.IsOpen,
			Title:     "hogehoge alert",
			Status:    mackerel.Alert.Status,
			AlertURL:  mackerel.Alert.URL,
			Trigger:   mackerel.Alert.Trigger,
			CreatedAt: mackerel.Alert.CreatedAt,
		}

		return response, nil
	})
}
