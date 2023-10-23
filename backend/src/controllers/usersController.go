package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	models "github.com/qwarden/sidejob/backend/src/models"
)

func GetUsers(c *gin.Context) {
	var users []models.User
	db.Find(&users)
	c.JSON(http.StatusOK, gin.H{"users": users})
}

func GetUserByID(c *gin.Context) {
	var user models.User
	userID := c.Param("userID")
	if err := db.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"Error": "User not found."})
		return
	}
	c.JSON(http.StatusOK, gin.H{"user": user})
}

func PostUser(c *gin.Context) {
	var user models.User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	db.Create(&user)
	c.JSON(http.StatusCreated, gin.H{"user": user})
}

func DeleteUser(c *gin.Context) {
	userID := c.Param("userID")
	if err := db.Delete(&models.User{}, userID).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error deleting user"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "User deleted successfully"})
}

func patchUser(c *gin.Context) {

}
