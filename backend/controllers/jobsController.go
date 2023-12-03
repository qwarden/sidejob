package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/db"
	"github.com/qwarden/sidejob/backend/auth"
	"github.com/qwarden/sidejob/backend/models"
)

type JobsController struct{}

func (j JobsController) RetrieveAll(c *gin.Context) {
  var jobs []models.Job
  db := db.GetDB()  

	db.Find(&jobs)
	c.JSON(http.StatusOK, gin.H{"jobs": jobs})
}

func (j JobsController) Create(c *gin.Context) {
  var job models.Job
  db := db.GetDB()

  userID, err := auth.GetIDFromContext(c)
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
    return 
  }
  
	if err := c.ShouldBindJSON(&job); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

  job.PostedByID = userID

	if err := db.Create(&job).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not create job"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"job": job})
}

func (j JobsController) Update(c *gin.Context) {
  var job models.Job
  db := db.GetDB()
  jobID := c.Param("jobID")

  userID, err := auth.GetIDFromContext(c)
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
    return 
  }

	if err := db.Where("id = ? AND posted_by_id = ?", jobID, userID).First(&job).Error; err != nil { 
    c.JSON(http.StatusNotFound, gin.H{"error": "could not find job for user"})
    return
  }

	if err := c.ShouldBindJSON(&job); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

  if err := db.Save(&job).Error; err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not update job"})
		return
	}

  c.JSON(http.StatusOK, gin.H{"job": job})
}

func (j JobsController) Delete(c *gin.Context) {
	db := db.GetDB()
	jobID := c.Param("jobID")

  userID, err := auth.GetIDFromContext(c)
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
    return 
  }

	if err := db.Where("id = ? AND posted_by_id = ?", jobID, userID).Delete(&models.Job{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not delete job"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "job deleted"})
}
