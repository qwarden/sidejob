package controllers

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/auth"
	"github.com/qwarden/sidejob/backend/config"
	"github.com/qwarden/sidejob/backend/db"
	"github.com/qwarden/sidejob/backend/models"
)

type AuthController struct {}

type Credentials struct {
  Email string `json:"email" binding:"required"`
  Password string `json:"password" binding:"required"`
}

type RefreshRequest struct {
  Token string `json:"refresh_token" binding:"required"`
}

func (a AuthController) Register(c *gin.Context) {
	var user models.User
  db := db.GetDB()
  tx := db.Begin()
  
  defer func() {
    if r := recover(); r != nil || tx.Error != nil {
      tx.Rollback()
    }
  }()

	if err := c.ShouldBindJSON(&user); err != nil {
    fmt.Print(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

  if err := user.HashPassword(user.Password); err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not hash password"})
  }

  if err := tx.Create(&user).Error; err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not create user"})
		return
	}


  accessToken, refreshToken, err := auth.CreateTokenPair(fmt.Sprintf("%d", user.ID))
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
    return
  } 

  if err := tx.Commit().Error; err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not commit registration transaction"})
    return
  }

  c.JSON(http.StatusCreated, gin.H{"access_token": accessToken, "refresh_token": refreshToken})
}

func (a AuthController) Login(c *gin.Context) {
  var creds Credentials 
  var user models.User 
  db := db.GetDB()

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
  
  accessToken, refreshToken, err := auth.CreateTokenPair(fmt.Sprintf("%d", user.ID))
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
    return
  } 

  c.JSON(http.StatusOK, gin.H{"access_token": accessToken, "refresh_token": refreshToken})
}

func (a AuthController) Refresh(c *gin.Context) {
  var request RefreshRequest
  cfg := config.GetConfig()

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

  userID, err := auth.ExtractIDFromToken(request.Token, cfg.RefreshSecret)
  if err != nil {
    c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
    return
  }

  accessToken, refreshToken, err := auth.CreateTokenPair(userID)
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
    return
  } 

  c.JSON(http.StatusOK, gin.H{"access_token": accessToken, "refresh_token": refreshToken})
}
