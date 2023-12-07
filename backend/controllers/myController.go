package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/auth"
	"github.com/qwarden/sidejob/backend/db"
	"github.com/qwarden/sidejob/backend/models"
)

type MyController struct{}

func (u MyController) Retrieve(c *gin.Context) {
	var user models.User
	db := db.GetDB()

	userID, err := auth.GetIDFromContext(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := db.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (u MyController) Update(c *gin.Context) {
	var user models.User
	db := db.GetDB()
	userID, err := auth.GetIDFromContext(c)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := db.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

	if err := db.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not update user"})
		return
	}

	c.JSON(http.StatusCreated, user)
}

func (u MyController) Delete(c *gin.Context) {
	db := db.GetDB()

	userID, err := auth.GetIDFromContext(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := db.Where("posted_by_id = ?", userID).Delete(&models.Job{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not delete user's jobs"})
		return
	}

	if err := db.Delete(&models.User{}, userID).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not delete user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "user and associated jobs deleted successfully"})
}

func (u MyController) RetrieveJobs(c *gin.Context) {
	var jobs []models.Job
	db := db.GetDB()

	userID, err := auth.GetIDFromContext(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}

	db.Where("posted_by_id = ?", userID).Find(&jobs)
	c.JSON(http.StatusOK, jobs)
}
