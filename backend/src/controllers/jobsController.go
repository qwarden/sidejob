package controllers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	models "github.com/qwarden/sidejob/backend/src/models"
	"gorm.io/gorm"
)

func GetJobsForUser(c *gin.Context) {
	var jobs []models.Job
	userID := c.Param("userID")
	db.Where("posted_by_id = ?", userID).Find(&jobs)
	c.JSON(http.StatusOK, gin.H{"jobs": jobs})
}

func GetJobForUser(c *gin.Context) {
	var job models.Job
	userID := c.Param("userID")
	jobID := c.Param("jobID")
	if err := db.Where("posted_by_id = ? AND id = ?", userID, jobID).First(&job).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Job not found!"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"job": job})
}

func PostJobForUser(c *gin.Context) {
	var job models.Job
	userID := c.Param("userID")

	intUserID, err := strconv.Atoi(userID)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"Bad Request Error": err.Error()})
		return
	}

	// validate user exists
	var user models.User
	if err := db.First(&user, intUserID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"Not Found Error": "User not found with that ID"})
		return
	}
	// validate job
	if err := c.ShouldBindJSON(&job); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"Bad Request Error": err.Error()})
		return
	}

	job.PostedByID = uint(intUserID)

	if err := db.Create(&job).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"Internal Server Error": err.Error()})
		return
	}

	if err := db.Create(&job).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"Internal Server Error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"job": job})
}

func PatchJobForUser(c *gin.Context) {

}

func DeleteJobForUser(c *gin.Context) {
	jobID := c.Param("jobID")
	if err := db.Delete(&models.Job{}, jobID).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error deleting job"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "Job deleted successfully"})
}
