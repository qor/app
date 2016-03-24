package app

type Application struct {
	Name   string
	Themes []*ThemeInterface
}

func New(name string) *Application {
	return &Application{Name: name}
}

func (app *Application) Use(theme *ThemeInterface) {
	app.Themes = append(app.Themes, theme)
}

func (app *Application) Create() error {
	for _, theme := range app.Themes {
	}
	return
}
