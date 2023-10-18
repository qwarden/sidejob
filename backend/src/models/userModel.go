package main

import (
  "gorm.io/gorm"
)

type User struct {
  gorm.Model
  ID       uint
  Name     string
  Email    string `gorm:"type:varchar(100);uniqueIndex"`
  Password string
  Jobs     []Job
}
