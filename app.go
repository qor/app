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

func (app *Application) Use(theme ThemeInterface) ThemeInterface {
	theme.SetApplication(app)
	theme.Initialize(theme)

	if configor, ok := theme.(ConfigureQorThemeInterface); ok {
		configor.ConfigureQorTheme(theme)
	}

	app.Themes = append(app.Themes, theme)
	return theme
}

func (app *Application) Create() (err error) {
Application:
	for _, theme := range app.Themes {
		if err = theme.CopyFiles(theme); err != nil {
			break Application
		}

		for _, plugin := range theme.GetPlugins() {
			if err = plugin.CopyFiles(plugin); err != nil {
				break Application
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
	var funcMap = app.funcMap

	funcMap["application_name"] = func() string {
		return app.Name
	}

	return funcMap
}

func (app *Application) RegisterFuncMap(name string, fc interface{}) {
	app.funcMap[name] = fc
}
