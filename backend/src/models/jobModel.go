package models

import (
	"gorm.io/gorm"
)

type Job struct {
	gorm.Model
	Title       string
	Description string
	JobPhoto    string // URL or ID of photo
	PayType     string // hourly, flat, or best offer
	PayAmount   int64  // in cents to avoid floating point errors
	Location    Location
	PostedByID  uint
	// Tags        []Tag
	// Interested  []User `gorm:"many2many:user_jobs;"`
	// CompletedBy uint   // ID of user who completed job
}
