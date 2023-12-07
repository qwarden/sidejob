package server

import (
	"net/http"

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

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"version": "1.0",
		})
	})

	myGroup := r.Group("my").Use(middleware.AuthHandler())
	{
		myCtrl := new(controllers.MyController)
		myGroup.GET("/profile", myCtrl.Retrieve)
		myGroup.GET("/jobs", myCtrl.RetrieveJobs)
		myGroup.PATCH("/profile", myCtrl.Update)
		myGroup.DELETE("/account", myCtrl.Delete)
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

	usersGroup := r.Group("users").Use(middleware.AuthHandler())
	{
		usersCtrl := new(controllers.UsersController)
		usersGroup.GET("/:userID", usersCtrl.RetrieveUser)
		usersGroup.GET("/:userID/jobs", usersCtrl.RetrieveUsersJob)
	}

	return r
}
