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
	ConfigureQorApplication(ThemeInterface)
}

func (app *Application) Use(theme ThemeInterface) ThemeInterface {
	theme.SetApplication(app)
	if configor, ok := theme.(ConfigureQorApplicationInterface); ok {
		configor.ConfigureQorApplication(theme)
	}

	app.Themes = append(app.Themes, theme)
	return theme
}

func (app *Application) Create() (err error) {
	for _, theme := range app.Themes {
		if err = theme.CopyFiles(theme); err != nil {
			break
		}

		for _, plugin := range theme.GetPlugins() {
			if err = plugin.CopyFiles(plugin); err != nil {
				break
			}
		}
	}

	if err == nil {
		for _, theme := range app.Themes {
			if err = theme.Build(theme); err != nil {
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
