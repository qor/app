package config

import (
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
	"github.com/qor/render"
)

var Render *render.Render
var DB *gorm.DB

func init() {
	Render = render.New()
	DB, _ = gorm.Open("sqlite3", "test.db")
}
