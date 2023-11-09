package models

import (
	"gorm.io/gorm"
)

type User struct {
	gorm.Model        // ID, CreatedAt, UpdatedAt, DeletedAt
  Email      string `gorm:"type:varchar(100);uniqueIndex;not null" json: "email"`
  Password   string `gorm:"not null" json: "password"` // Will be hashed & salted
  Name       string `gorm:"not null" json: "name"`
  About      string `gorm:"type:text" json: "about"`

	// TODO: Use MinIO https://fly.io/docs/app-guides/minio/
	// (Hosts S3-compatible object storage for user photos)
	// UserPhoto string // URL or ID of photo

	Jobs    []Job `gorm:"foreignKey:PostedByID"`

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
