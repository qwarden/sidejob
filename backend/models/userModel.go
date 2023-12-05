package models

import (
	"gorm.io/gorm"
  "golang.org/x/crypto/bcrypt"
)

type User struct {
	gorm.Model        // ID, CreatedAt, UpdatedAt, DeletedAt
  Email      string `gorm:"type:varchar(100);uniqueIndex;not null" json:"email"`
  Password   string `gorm:"type:varchar(255);not null" json:"password"`
  Name       string `gorm:"not null" json:"name"`
  About      string `gorm:"type:text" json:"about"`
}

func (u *User) HashPassword(password string) error {
  bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)

  if err != nil {
    return err
  }

  u.Password = string(bytes)
  return nil
}

func (u User) CheckPassword(password string) error {
 return bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(password))
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
