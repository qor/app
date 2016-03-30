package ios_ec

import "github.com/qor/app"

type EC struct {
	app.Theme
	Path string
}

func (ec *EC) GetTemplatesPath() string {
	if ec.TemplatesPath == "" {
		ec.TemplatesPath = "github.com/qor/app/ios_ec/templates"
	}
	return ec.Theme.GetTemplatesPath()
}

func (ec *EC) ConfigureQorTheme(theme app.ThemeInterface) {
	ec.Theme.Path = ec.Path
	return
}

func (ec *EC) Build(theme app.ThemeInterface) error {
	return nil
}
