package products

import "github.com/qor/app"

type Product struct {
	app.Plugin
}

// config/admin/admin.go
// 	Admin.AddResource(&models.Product{})

// config/routers/routes.go
//   insert route
