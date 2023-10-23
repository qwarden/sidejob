package main

import "gorm.io/gorm"

type Server struct {
	db *gorm.DB
	// config, logger, etc.
}

func NewServer(db *gorm.DB) *Server {
	return &Server{
		db: db,
	}
}
