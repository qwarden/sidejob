package models

import "gorm.io/gorm"

type Tag struct {
	gorm.Model
	Name string `gorm:"type:varchar(100);not null" json:"name"`
	Jobs []Job  `gorm:"many2many:jobTags;"` // Stores all jobs with this tag
}
