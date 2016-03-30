package products

import "github.com/qor/app"

type Product struct {
	app.Plugin
}

func (product *Product) GetTemplatesPath() string {
	if product.TemplatesPath == "" {
		product.TemplatesPath = "github.com/qor/app/modules/products/templates"
	}
	return product.Plugin.GetTemplatesPath()
}
