package models

import (
	"gorm.io/gorm"
)

type Job struct {
	gorm.Model
  Title       string `json: "title"`
  Description string `json: "description"`
  Photo       string `json: "photo"` // URL or ID of photo
  PayType     string `json: "paytype"` // hourly, flat, or best offer
  PayAmount   int64  `json: "payamount"` // in cents to avoid floating point errors
  LocationID  uint   `json: "location_id"`
	Location    Location `gorm:"foreignKey:LocationID"`
  PostedByID  uint   `json: "posted_by_id"`// Foreign key
	PostedBy    User `gorm:"foreignKey:PostedByID"`
	// Tags        []Tag
	// Interested  []User `gorm:"many2many:user_jobs;"`
	// CompletedBy uint   // ID of user who completed job
}
