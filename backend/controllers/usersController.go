package controllers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/auth"
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

func (u UsersController) RetrieveUsersJob(c *gin.Context) {
	var job []models.Job
	db := db.GetDB()
	jobID := c.Param("job_id")

	userID, err := auth.GetIDFromContext(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}

	if err := db.Where("posted_by_id = ? AND id = ?", userID, jobID).First(&job).Error; err != nil {
		c.JSON(http.StatusOK, gin.H{"jobs": []models.Job{}})
		return
	}

	c.JSON(http.StatusOK, job)
}

func (u UsersController) RetrieveUser(c *gin.Context) {
	var user models.User
	db := db.GetDB()
	userID := c.Param("user_id")

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
