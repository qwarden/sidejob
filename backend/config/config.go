package config

import (
  "os"
  "fmt"
)

type Config struct {
  AccessSecret string
  RefreshSecret string
  AccessExpriy string
  RefreshExpiry string
  DatabaseUrl string
}

var config *Config

func GetEnv(key string) string {
  val := os.Getenv(key)

	if val == "" {
    panic(fmt.Sprintf("env var %s is not set", key))
	} 

  return val
}

func Load() {
  config = &Config{
    AccessSecret: GetEnv("ACCESS_SECRET"),
    RefreshSecret: GetEnv("REFRESH_SECRET"),
    AccessExpriy: GetEnv("ACCESS_EXPIRY"),
    RefreshExpiry: GetEnv("REFRESH_EXPIRY"),
    DatabaseUrl: GetEnv("DATABASE_URL"),
  }
}

func GetConfig() *Config {
  if config == nil {
    panic("config has not been loaded")
  }

  return config
}
