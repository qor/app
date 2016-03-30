package app

import (
	"errors"
	"html/template"
	"os"
	"path/filepath"
	"strings"
)

type ConfigureQorThemeInterface interface {
	ConfigureQorTheme(ThemeInterface)
}

type ThemeInterface interface {
	GetName() string
	GetPath() string
	GetTemplatesPath() string
	CopyFiles(ThemeInterface) error
	Build(ThemeInterface) error
	GetApplication() *Application
	SetApplication(*Application)
	UsePlugin(plugin PluginInterface)
	GetPlugins() []PluginInterface
	GetPlugin(name string) PluginInterface
	FuncMap() template.FuncMap
}

type Theme struct {
	Name          string
	Path          string
	TemplatesPath string
	Application   *Application
	Plugins       []PluginInterface
}

func (theme *Theme) GetName() string {
	return theme.Name
}

func (theme *Theme) GetPath() string {
	return theme.Path
}

func (theme *Theme) GetTemplatesPath() string {
	if theme.TemplatesPath != "" {
		if pth, ok := isExistingDir(filepath.Join(root, "vendor", theme.TemplatesPath)); ok {
			return pth
		}

		for _, gopath := range strings.Split(os.Getenv("GOPATH"), ":") {
			if pth, ok := isExistingDir(filepath.Join(gopath, "src", theme.TemplatesPath)); ok {
				return pth
			}
		}
	}

	return theme.TemplatesPath
}

// Patch model, functions (golang, java, swift)
func (*Theme) CopyFiles(theme ThemeInterface) error {
	return copyFiles(theme.GetTemplatesPath(), theme.GetPath(), theme.FuncMap(), theme)
}

func (*Theme) Build(theme ThemeInterface) error {
	return errors.New("Build not implemented for Theme " + theme.GetName())
}

// Theme Application
func (theme *Theme) GetApplication() *Application {
	return theme.Application
}

func (theme *Theme) SetApplication(app *Application) {
	theme.Application = app
}

// Theme Plugins
func (theme *Theme) UsePlugin(plugin PluginInterface) {
	plugin.SetTheme(theme)

	if configor, ok := plugin.(ConfigureQorPluginInterface); ok {
		configor.ConfigureQorPlugin(plugin)
	}

	theme.Plugins = append(theme.Plugins, plugin)
}

func (theme *Theme) GetPlugins() []PluginInterface {
	return theme.Plugins
}

func (theme *Theme) GetPlugin(name string) PluginInterface {
	for _, plugin := range theme.Plugins {
		if name == plugin.GetName() {
			return plugin
		}
	}
	return nil
}

// FuncMap
func (theme *Theme) FuncMap() template.FuncMap {
	funcMap := theme.GetApplication().FuncMap()
	funcMap["has_plugin"] = func(name string) bool {
		for _, plugin := range theme.GetPlugins() {
			if plugin.GetName() == name {
				return true
			}
		}
		return false
	}
	return funcMap
}
