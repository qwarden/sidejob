package models

import (
	"gorm.io/gorm"
)

type User struct {
	gorm.Model        // ID, CreatedAt, UpdatedAt, DeletedAt
	Email      string `gorm:"type:varchar(100);uniqueIndex;not null"`
	Password   string `gorm:"not null"` // Will be hashed & salted
	Name       string `gorm:"not null"`
	About      string `gorm:"type:text"`

	// TODO: Use MinIO https://fly.io/docs/app-guides/minio/
	// (Hosts S3-compatible object storage for user photos)
	// UserPhoto string // URL or ID of photo

	JobsPosted    []Job
	JobsCompleted []Job `gorm:"many2many:user_jobs;"`

	// TODO: Ratings
	// RatingsReceived []Rating
}

// type Rating struct {
// 	gorm.Model
// 	Score      float
// 	ReviewerID uint
// 	RevieweeID uint
// 	Comment    string
// }

// type Tag struct {
// 	ID   uint `gorm:"primaryKey"`
// 	Name string
// }
