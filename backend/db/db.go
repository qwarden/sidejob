package db

import (
	"fmt"
	"log"
	"os"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"github.com/qwarden/sidejob/backend/models"
)

var db *gorm.DB

func Init() {
	dsn := os.Getenv("DATABASE_URL")
	config := gorm.Config{}
	timeout := 5 * time.Minute
  var err error

	db, err = WaitForDB(dsn, &config, timeout)

	if err != nil {
		panic("Failed to connect to database: " + err.Error())
	}

	err = db.AutoMigrate(&models.User{}, &models.Job{})

	if err != nil {
		panic("Failed to migrate database: " + err.Error())
	}
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

func GetDB() *gorm.DB {
  if db == nil {
    panic("uninitialized db")
  }

  return db
}
