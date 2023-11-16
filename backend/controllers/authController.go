package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/models"
	"github.com/qwarden/sidejob/backend/db"
	"github.com/qwarden/sidejob/backend/auth"
)

type AuthController struct {}

type Credentials struct {
  Email string `json: "email" binding: "required"`
  Password string `json: "password" binding: "required"`
}

type RefreshRequest struct {
  Token string `json: "request_token" binding: "required"`
}


func (a AuthController) Login(c *gin.Context) {
  db := db.GetDB()
  var creds Credentials 
  var user models.User 

	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

  if err := db.First(&user, "email = ?", creds.Email).Error; err != nil {
    c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid email"})
    return
  }

  if err := user.CheckPassword(creds.Password); err != nil {
    c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid password"})
    return
  }
  
  accessToken, requestToken := auth.CreateTokenPair(c, user.ID)

  c.JSON(http.StatusOk, gin.H{"access_token": accessToken, "request_token": requestToken})
}

func (a AuthController) Refresh(c *gin.Context) {
  db := db.GetDB() 
  var request RefreshRequest



}


