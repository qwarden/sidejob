package main

import (
	server "github.com/qwarden/sidejob/backend/src/server"
)

func main() {
	db := server.InitDB()
	s := server.NewServer(db)
	s.Run(":8080")
}
