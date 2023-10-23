package server

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	controllers "github.com/qwarden/sidejob/backend/src/controllers"
	models "github.com/qwarden/sidejob/backend/src/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Server struct {
	DB     *gorm.DB
	Router *gin.Engine
}

var _ controllers.ServerInterface = &Server{}

func (s *Server) GetRouter() *gin.Engine {
	return s.Router
}

func (s *Server) GetDB() *gorm.DB {
	return s.DB
}

func NewServer(db *gorm.DB) *Server {
	server := &Server{
		DB:     db,
		Router: gin.Default(),
	}
	server.InitRoutes()
	return server
}

func (s *Server) InitRoutes() {
	r := s.Router

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"version": "1.0",
		})
	})

	// User Routes
	r.GET("/users", func(c *gin.Context) {
		controllers.GetUsers(c, s.DB)
	})
	r.GET("/users/:userID", func(c *gin.Context) {
		controllers.GetUserByID(c, s.DB)
	})
	r.GET("/users/:userID/jobs", func(c *gin.Context) {
		controllers.GetJobsForUser(c, s.DB)
	})
	r.GET("/users/:userID/jobs/:jobID", func(c *gin.Context) {
		controllers.GetJobForUser(c, s.DB)
	})
	r.POST("/users", func(c *gin.Context) {
		controllers.PostUser(c, s.DB)
	})
	r.POST("/users/:userID/jobs", func(c *gin.Context) {
		controllers.PostJobForUser(c, s.DB)
	})
	r.PATCH("/users/:userID", func(c *gin.Context) {
		controllers.PatchUser(c, s.DB)
	})
	r.PATCH("/users/:userID/jobs/:jobID", func(c *gin.Context) {
		controllers.PatchJobForUser(c, s.DB)
	})
	// Job Routes
	r.GET("/jobs", func(c *gin.Context) {
		controllers.GetJobsForUser(c, s.DB)
	})
}

func (s *Server) Run(addr string) {
	s.Router.Run(addr)
}

func InitDB() *gorm.DB {
	dsn := os.Getenv("DATABASE_URL")
	config := gorm.Config{}
	timeout := 5 * time.Minute

	db, err := WaitForDB(dsn, &config, timeout)

	if err != nil {
		panic("Failed to connect to database: " + err.Error())
	}

	err = db.AutoMigrate(&models.User{}, &models.Job{})

	if err != nil {
		panic("Failed to migrate database: " + err.Error())
	}

	return db
}

func WaitForDB(dsn string, config *gorm.Config, timeout time.Duration) (*gorm.DB, error) {
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
