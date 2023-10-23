package controllers

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// interface prevents cyclic imports
type ServerInterface interface {
	GetRouter() *gin.Engine
	GetDB() *gorm.DB
}
