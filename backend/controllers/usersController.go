package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/models"
	"github.com/qwarden/sidejob/backend/db"
)

type UsersController struct {}

func (u UsersController) Retrieve(c *gin.Context) {
  db := db.GetDB()
	userID := c.Param("userID")
	var user models.User

	if err := db.First(&user, userID).Error; err != nil { 
      c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"user": user})
}

func (u UsersController) Create(c *gin.Context) {
  db := db.GetDB()
	var user models.User

	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request json"})
		return
	}

  if err := db.Create(&user).Error; err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not update user"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"user": user})
}

func (u UsersController) Update(c *gin.Context) {
  db := db.GetDB()
  userID := c.Param("userID")
  var user models.User

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
	userID := c.Param("userID")

	if err := db.Delete(&models.User{}, userID).Error; err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "could not delete user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "user deleted successfully"})
}

func (u *UsersController) RetrieveJobs(c *gin.Context) {
  db := db.GetDB()
	userID := c.Param("userID")
	var jobs []models.Job

	db.Where("posted_by_id = ?", userID).Find(&jobs)
	c.JSON(http.StatusOK, gin.H{"jobs": jobs})
}

func (u *UsersController) RetrieveJob(c *gin.Context) {
  db := db.GetDB()

	var job models.Job
	userID := c.Param("userID")
	jobID := c.Param("jobID")

	if err := db.Where("posted_by_id = ? AND id = ?", userID, jobID).First(&job).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "job not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"job": job})
}
