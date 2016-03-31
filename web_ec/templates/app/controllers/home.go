package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/qor/app/example/app/models"
	"github.com/qor/app/web_ec/templates/config"
)

func Index(c *gin.Context) {
	var products []models.Product
	config.DB.Find(&products)

	c.JSON(http.StatusOK, products)
}
