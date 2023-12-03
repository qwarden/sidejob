package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/models"
	"github.com/qwarden/sidejob/backend/db"
	"github.com/qwarden/sidejob/backend/auth"
)

type UsersController struct {}

func (u UsersController) Retrieve(c *gin.Context) {
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

	c.JSON(http.StatusOK, gin.H{"user": user})
}


func (u UsersController) Update(c *gin.Context) {
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

	c.JSON(http.StatusCreated, gin.H{"user": user})
}

func (u UsersController) Delete(c *gin.Context) {
  db := db.GetDB()

  userID, err := auth.GetIDFromContext(c)
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
  }

	if err := db.Delete(&models.User{}, userID).Error; err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not delete user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "user deleted successfully"})
}

func (u UsersController) RetrieveJobs(c *gin.Context) {
	var jobs []models.Job
  db := db.GetDB()

  userID, err := auth.GetIDFromContext(c)
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
  }

	db.Where("posted_by_id = ?", userID).Find(&jobs)
	c.JSON(http.StatusOK, gin.H{"jobs": jobs})
}

func (u *UsersController) RetrieveJob(c *gin.Context) {
	var job []models.Job
  db := db.GetDB()
	jobID := c.Param("jobID")

  userID, err := auth.GetIDFromContext(c)
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
  }

	if err := db.Where("posted_by_id = ? AND id = ?", userID, jobID).First(&job).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "job not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"job": job})
}
