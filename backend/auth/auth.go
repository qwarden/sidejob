package auth

import (
  "time"
  "net/http"
  "fmt"

  "github.com/golang-jwt/jwt/v5"
	"github.com/gin-gonic/gin"
)

type Claims struct {
  ID string `json: "id" binding: "required"`
  jwt.RegisteredClaims 
}

func CreateToken(id string, secret string, expiry time.Duration) (string, error) {
  claims := &Claims {
    id,
    jwt.RegisteredClaims{
      ExpiresAt: jwt.NewNumericDate(time.Now().Add(expiry)),
    },
  }

  token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
  return token.SignedString([]byte(secret))
}

func ParseToken(tokenString string, secret string) (jwt.Token, error) {
  token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
    if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
      return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
    }
    return []byte(secret), nil
  })

	return *token, err 
}

func CreateTokenPair(c *gin.Context, id string) (string, string) {
  accessToken, err := CreateToken(id, accessSecret, accessExpiry) 
  
  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to sign access token"})
    c.Abort()
  }

  requestToken, err := CreateToken(id, refreshSecret, requestExpiry)

  if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to sign request token"})
    c.Abort()
  }

  return accessToken, requestToken
}
