package main

import (
  "gorm.io/gorm"
)

type Job struct {
  gorm.Model
  ID          uint
  Name        string
  Address     string
  Description string
  UserID      uint
}
