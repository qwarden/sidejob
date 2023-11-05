package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/models"
	"github.com/qwarden/sidejob/backend/db"
)

type JobsController struct {}

func (j JobsController) RetrieveAll(c *gin.Context) {
  db := db.GetDB()  
  var jobs []models.Job

  db.Find(&jobs)
  c.JSON(http.StatusOK, gin.H{"jobs": jobs})
}

func (j JobsController) Create(c *gin.Context) {
  db := db.GetDB()
  var job models.Job

	if err := c.ShouldBindJSON(&job); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

	if err := db.Create(&job).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not create job" })
		return
	}

	c.JSON(http.StatusCreated, gin.H{"job": job})
}

func (j JobsController) Update(c *gin.Context) {
  db := db.GetDB()
  jobID := c.Param("jobID")
  var job models.Job

	if err := db.First(&job, jobID).Error; err != nil { 
      c.JSON(http.StatusNotFound, gin.H{"error": "job not found"})
		return
  }

	if err := c.ShouldBindJSON(&job); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

  if err := db.Save(&job).Error; err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not update user"})
		return
	}

  c.JSON(http.StatusCreated, gin.H{"job": job})
}

func (j JobsController) Delete(c *gin.Context) {
  db := db.GetDB()
	jobID := c.Param("jobID")

	if err := db.Delete(&models.Job{}, jobID).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not delete job"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "job delete"})
}
