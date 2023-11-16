package server

import (
  "net/http"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/controllers"
)

func Init() {
  r := NewRouter()
  r.Run(":8080")
}

func NewRouter() *gin.Engine {
	r := gin.Default()

  router.Use(func(c *gin.Context) {
		path := c.Request.URL.Path
		if len(path) > 1 && path[len(path)-1] == '/' {
			normalizedPath := strings.TrimRight(path, "/")
			c.Request.URL.Path = normalizedPath
		}
		c.Next()
	})

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"version": "1.0",
		})
	})

  userGroup := r.Group("users")
  {
    userCtrl := new(controllers.UsersController)
    userGroup.GET("/:userID", userCtrl.Retrieve)
    userGroup.GET("/:userID/jobs", userCtrl.RetrieveJobs)
    userGroup.GET(":userID/jobs/:jobID", userCtrl.RetrieveJob)
    userGroup.POST("/", userCtrl.Create)
    userGroup.PATCH("/:userID", userCtrl.Update)
    userGroup.DELETE("/:userID", userCtrl.Delete)
  }

  jobGroup := r.Group("jobs")
  {
    jobCtrl := new(controllers.JobsController)
    jobGroup.GET("/", jobCtrl.RetrieveAll)
    jobGroup.POST("/", jobCtrl.Create)
    jobGroup.PATCH("/:jobID", jobCtrl.Update)
    jobGroup.DELETE("/:jobID", jobCtrl.Delete)
  }

  return r
}
