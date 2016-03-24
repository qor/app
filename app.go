package app

import (
	"fmt"
	"html/template"
)

type Application struct {
	Name    string
	Themes  []ThemeInterface
	funcMap template.FuncMap
}

func New(name string) *Application {
	return &Application{Name: name, funcMap: map[string]interface{}{}}
}

type ConfigureQorApplicationInterface interface {
	ConfigureQorApplication(*Application)
}

func (app *Application) Use(theme ThemeInterface) {
	if configor, ok := theme.(ConfigureQorApplicationInterface); ok {
		configor.ConfigureQorApplication(app)
	}

	app.Themes = append(app.Themes, theme)
}

func (app *Application) Create() (err error) {
	for _, theme := range app.Themes {
		if err = theme.CopyFiles(app); err != nil {
			break
		}
	}

	if err == nil {
		for _, theme := range app.Themes {
			if err = theme.Build(app); err != nil {
				break
			}
		}
	}

	if err != nil {
		fmt.Println("Failed to create application:", err)
	}
	return
}

func (app *Application) FuncMap() template.FuncMap {
	return app.funcMap
}

func (app *Application) RegisterFuncMap(name string, fc interface{}) {
	app.funcMap[name] = fc
}
