package controllers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/db"
	"github.com/qwarden/sidejob/backend/models"
)

type UsersController struct{}

type UserResponse struct {
	ID        uint      `json:"id"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Email     string    `json:"email"`
	Name      string    `json:"name"`
  About     string    `json:"about"`
}

func (u UsersController) RetrieveUsersJobs(c *gin.Context) {
	var jobs []models.Job
	db := db.GetDB()
  userID := c.Param("userID")

	db.Where("posted_by_id = ?", userID).Find(&jobs)

	c.JSON(http.StatusOK, jobs)
}

func (u UsersController) RetrieveUser(c *gin.Context) {
	var user models.User
	db := db.GetDB()
	userID := c.Param("userID")

	if err := db.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	userResponse := UserResponse{
		ID:        user.ID,
		CreatedAt: user.CreatedAt,
		UpdatedAt: user.UpdatedAt,
		Email:     user.Email,
		Name:      user.Name,
		About:     user.About,
	}

	c.JSON(http.StatusOK, userResponse)
}
