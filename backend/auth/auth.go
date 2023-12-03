package auth

import (
	"fmt"
	"time"
  "strconv"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/qwarden/sidejob/backend/config"
)

type CustomClaims struct {
  UserID string `json:"user_id" binding:"required"`
  jwt.RegisteredClaims 
}

func CreateToken(user_id string, secret string, expiry string) (string, error) {
  // The expiry string passed in should be able to parsed by parse duration 
  // The ones in the provided .env.sample should work fine
  exp, err := time.ParseDuration(expiry)

  if err != nil {
    return "", err
  }

  claims := &CustomClaims {
    user_id,
    jwt.RegisteredClaims{
      ExpiresAt: jwt.NewNumericDate(time.Now().Add(exp)),
    },
  }

  token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
  return token.SignedString([]byte(secret))
}

func CreateTokenPair(user_id string) (accessToken string, refreshToken string, err error) {
  cfg := config.GetConfig()

  accessToken, err = CreateToken(user_id, cfg.AccessSecret, cfg.AccessExpriy) 
  if err != nil {
    return "", "", fmt.Errorf("failed to create access token")
  }

  refreshToken, err = CreateToken(user_id, cfg.RefreshSecret, cfg.RefreshExpiry)
  if err != nil {
    return "", "", fmt.Errorf("failed to create refresh token")
  }

  return accessToken, refreshToken, nil
}

func ExtractIDFromToken(tokenString string, secret string) (string, error) {
    token, err := jwt.ParseWithClaims(tokenString, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
        return []byte(secret), nil
    }, jwt.WithValidMethods([]string{"HS256"}))

    if err != nil {
        return "", fmt.Errorf("failed to parse token") 
    }

    claims, ok := token.Claims.(*CustomClaims)
    if !ok || !token.Valid {
      return "", fmt.Errorf("invalid token")
    }

    return claims.UserID, nil
}

func GetIDFromContext(c *gin.Context) (uint, error) {
  cUserID, exists := c.Get("user-id")
  if !exists {
    return 0, fmt.Errorf("user-id not in context")
  }

  strUserID, ok := cUserID.(string)
  if !ok {
    return 0, fmt.Errorf("user-id is not a string")
  }

  userID, err := strconv.ParseUint(strUserID, 10, 32)
  if err != nil {
      return 0, fmt.Errorf("invalid user-id format")
  }

  return uint(userID), nil
}
