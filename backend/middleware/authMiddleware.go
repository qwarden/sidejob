package middleware

import (
	"net/http"
  "strings"

	"github.com/gin-gonic/gin"
	"github.com/qwarden/sidejob/backend/auth"
	"github.com/qwarden/sidejob/backend/config"
)

func AuthHandler() gin.HandlerFunc {
  return func (c *gin.Context) {
    cfg := config.GetConfig()
    authHeader := strings.Split(c.Request.Header.Get("Authorization"), " ")

    if len(authHeader) != 2 {
      c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
      c.Abort()
      return
    }
    
    token := authHeader[1]
    userID, err := auth.ExtractIDFromToken(token, cfg.AccessSecret)

    if err != nil {
      c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
      c.Abort()
      return
    }

    c.Set("user-id", userID)
    c.Next()
  }
}
