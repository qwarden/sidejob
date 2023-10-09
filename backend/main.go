package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
    "gorm.io/driver/mysql"
)

// var db *gorm.DB

func main() {
  r := init_router()
  init_db()

  r.Run(":8080")
}

func init_router() *gin.Engine {
    r := gin.Default()

    r.GET("/", func (c *gin.Context) {
      c.JSON(http.StatusOK, gin.H{
        "version": "1.0",
      })
  })

    // User Routes
    r.GET("/users", getUsers)
    r.GET("/users/:userID", getUserByID)
    r.GET("/users/:userID/jobs", getJobsForUser)
    r.GET("/users/:userID/jobs/:jobID", getJobForUser)

    r.POST("/users", postUser)
    r.POST("/users/:userID/jobs", postJobForUser)

    r.PATCH("/users/:userID", patchUser)
    r.PATCH("/users/:userID/jobs/:jobID", patchJobForUser)

    // Job Routes
    r.GET("/jobs", getJobs)

    return r
}

func init_db() *gorm.DB {
    dsn := "user:pass@tcp(127.0.0.1:3306)/dbname?charset=utf8mb4&parseTime=True&loc=Local"
    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})

    if err != nil {
      panic("Failed to connect to database: " + err.Error())
    }

    err = db.AutoMigrate(&User{}, &Job{})

    if err != nil {
      panic("Failed to migrate database: " + err.Error())
    }

    return db
}


