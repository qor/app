package web_ec

import "github.com/qor/app"

var EC = &ECTheme{}

func init() {
	EC.TemplatesPath = "github.com/qor/app/web_ec/templates"
}

type ECTheme struct {
	app.Theme
}

func (ec ECTheme) ConfigureQorApplication(app *app.Application) {
	return
}
