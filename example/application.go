package main

import (
	"github.com/qor/app"
	"github.com/qor/app/ios_ec"
	"github.com/qor/app/web_ec"
)

func main() {
	Application := app.New("example")
	theme := Application.Use(&web_ec.EC{})
	product := theme.GetPlugin("Product")
	product.EnableOption("l10n")

	Application.Use(&ios_ec.EC{Path: "iOS"})
	Application.Create()
}
