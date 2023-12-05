package main

import (
	"github.com/qwarden/sidejob/backend/db"
  "github.com/qwarden/sidejob/backend/server"
  "github.com/qwarden/sidejob/backend/config"
)

func main() {
  config.Load()
	db.Init()
  server.Init()
}
