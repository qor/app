package app

import "html/template"

type Application struct {
	Name    string
	Themes  []ThemeInterface
	funcMap template.FuncMap
}

func New(name string) *Application {
	return &Application{Name: name, funcMap: map[string]interface{}{}}
}

func (app *Application) Use(theme ThemeInterface) {
	app.Themes = append(app.Themes, theme)
}

func (app *Application) Create() (err error) {
	for _, theme := range app.Themes {
		if err = theme.CopyFiles(); err != nil {
			break
		}
	}

	if err == nil {
		for _, theme := range app.Themes {
			if err = theme.Build(); err != nil {
				break
			}
		}
	}

	return
}

func (app *Application) FuncMap() template.FuncMap {
	return app.funcMap
}

func (app *Application) RegisterFuncMap(name string, fc interface{}) {
	app.funcMap[name] = fc
}
