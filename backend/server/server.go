package server

import (
  "net/http"
  "path"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/controllers"
	"github.com/qwarden/sidejob/backend/middleware"
)

func Init() {
	r := NewRouter()
	r.Run(":8080")
}

func NewRouter() *gin.Engine {
	r := gin.Default()

  r.Use(func(c *gin.Context) {
    c.Request.URL.Path = path.Clean(c.Request.URL.Path)
		c.Next()
  })

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"version": "1.0",
		})
	})

  userGroup := r.Group("my").Use(middleware.AuthHandler())
  {
    userCtrl := new(controllers.UsersController)
    userGroup.GET("/profile", userCtrl.Retrieve)
    userGroup.GET("/jobs", userCtrl.RetrieveJobs)
    userGroup.PATCH("/profile", userCtrl.Update)
    userGroup.DELETE("/account", userCtrl.Delete)
  }

  jobGroup := r.Group("jobs").Use(middleware.AuthHandler())
  {
    jobCtrl := new(controllers.JobsController)
    jobGroup.GET("/", jobCtrl.RetrieveAll)
    jobGroup.POST("/", jobCtrl.Create)
    jobGroup.PATCH("/:jobID", jobCtrl.Update)
    jobGroup.DELETE("/:jobID", jobCtrl.Delete)
  }

  authGroup := r.Group("auth")
  {
    authCtrl := new(controllers.AuthController)
    authGroup.POST("/register", authCtrl.Register)
    authGroup.POST("/login", authCtrl.Login)
    authGroup.POST("/refresh", authCtrl.Refresh)
  }

  return r
}
