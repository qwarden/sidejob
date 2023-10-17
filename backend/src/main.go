package main

import (
    "net/http"
    "os"
    "fmt"
    "time"
    "log"

    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
    "gorm.io/driver/postgres"
)

// var db *gorm.DB

func main() {
  r := initRouter()
  initDB()
  
  r.Run(":8080")
}

func initRouter() *gin.Engine {
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

func initDB() *gorm.DB {
    dsn := os.Getenv("DATABASE_URL") 
    config := gorm.Config{}
    timeout := 5 * time.Minute

    db, err := waitForDB(dsn, &config, timeout)

    if err != nil {
      panic("Failed to connect to database: " + err.Error())
    }

    err = db.AutoMigrate(&User{}, &Job{})

    if err != nil {
      panic("Failed to migrate database: " + err.Error())
    }

    return db
}

func waitForDB(dsn string, config *gorm.Config, timeout time.Duration) (*gorm.DB, error) {
    ticker := time.NewTicker(time.Second)
    defer ticker.Stop()

    timeoutExceeded := time.After(timeout)

    for {
      select {
      case <-timeoutExceeded:
        return nil, fmt.Errorf("db connection failed after %s timeout", timeout)

      case <-ticker.C:
        db, err := gorm.Open(postgres.Open(dsn), config)

        if err == nil {
          return db, nil
        } 

        log.Println(fmt.Errorf("%w failed to connect to db %s", err, dsn))
    }
  }
}

