package web_ec

import "github.com/qor/app"

type EC struct {
	app.Theme
}

func (ec *EC) GetTemplatesPath() string {
	if ec.TemplatesPath == "" {
		ec.TemplatesPath = "github.com/qor/app/web_ec/templates"
	}
	return ec.Theme.GetTemplatesPath()
}

func (ec *EC) ConfigureQorApplication(app *app.Application) {
	return
}

func (ec *EC) Build(app *app.Application) {
	return
}
