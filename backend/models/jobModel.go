package models

import (
	"gorm.io/gorm"
)

type Job struct {
	gorm.Model
	Title       string `json:"title"`
	Description string `json:"description"`
	PayType     string `json:"pay_type"`   // hourly, flat, or best offer
	PayAmount   uint   `json:"pay_amount"` // in cents to avoid floating point errors
	Location    string `json:"location"`
	PostedByID  uint   `json:"-"` // Foreign key
	// Tags        []Tag
	// Interested  []User `gorm:"many2many:user_jobs;"`
	// CompletedBy uint   // ID of user who completed job
}
