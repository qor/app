package web_ec

import (
	"os/exec"

	"github.com/qor/app"
	"github.com/qor/app/modules/cart"
	"github.com/qor/app/modules/products"
)

type EC struct {
	Path string
	app.Theme
}

func (ec *EC) ConfigureQorTheme(theme app.ThemeInterface) {
	ec.Theme.Path = ec.Path

	// Add Product Plugin
	ec.UsePlugin(&products.Product{})
	ec.UsePlugin(&cart.Cart{})
	return
}

func (ec *EC) Build(theme app.ThemeInterface) error {
	return exec.Command("gofmt", "-s", "-w", ".").Run()
}
