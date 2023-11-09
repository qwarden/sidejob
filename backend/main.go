package main

import (
	"github.com/qwarden/sidejob/backend/db"
  "github.com/qwarden/sidejob/backend/server"
)

func main() {
	db.Init()
  server.Init()
}
