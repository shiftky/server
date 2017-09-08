package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
)

type Alerts struct {
	Alerts []Alert `json:"alerts"`
}

type Alert struct {
	Id        string `json:"id"`
	OrgName   string `json:"orgName"`
	Title     string `json:"title"`
	Status    string `json:"status"`
	IsOpen    bool   `json:"isOpen"`
	Url       string `json:"url"`
	Trigger   string `json:"trigger"`
	CreatedAt string `json:"createdAt"`
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
		var alerts []Alert

		alerts = append(alerts, Alert{
			Id:        "35UYbW8t1j5",
			OrgName:   "gazou",
			Title:     "prd-db/check_load: CheckLoad CRITICAL: Per core load average (12 CPU): [3.58, 3.49, 2.31]",
			Status:    "critical",
			IsOpen:    true,
			Url:       "https://example.com/alert",
			Trigger:   "monitor",
			CreatedAt: "2017-09-07 18:41:44 +0900",
		})

		alerts = append(alerts, Alert{
			Id:        "123ABCDEFG",
			OrgName:   "gazou",
			Title:     "prd-db/check_load: CheckLoad OK: Per core load average (12 CPU): [0.08, 1.29, 1.90]",
			Status:    "ok",
			IsOpen:    false,
			Url:       "https://example.com/alert",
			Trigger:   "monitor",
			CreatedAt: "2017-09-07 20:30:00 +0900",
		})

		return Alerts{
			Alerts: alerts,
		}, nil
	})
}
