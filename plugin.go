package app

import (
	"html/template"
	"os"
	"path/filepath"
	"strings"
)

type PluginInterface interface {
	GetName() string
	EnableOption(name string) error
	DisableOption(name string) error
	EnabledOptions() []string
	EnabledOption(name string) bool
	GetTemplatesPath() string
	CopyFiles(PluginInterface) error // copy files for web, android, ios
	GetTheme() ThemeInterface
	SetTheme(theme ThemeInterface)
	FuncMap() template.FuncMap
}

type Plugin struct {
	Name          string
	TemplatesPath string
	Options       []string
	Theme         ThemeInterface
}

func (plugin *Plugin) GetName() string {
	return plugin.Name
}

func (plugin *Plugin) GetTemplatesPath() string {
	if plugin.TemplatesPath != "" {
		if pth, ok := isExistingDir(filepath.Join(root, "vendor", plugin.TemplatesPath)); ok {
			return pth
		}

		for _, gopath := range strings.Split(os.Getenv("GOPATH"), ":") {
			if pth, ok := isExistingDir(filepath.Join(gopath, "src", plugin.TemplatesPath)); ok {
				return pth
			}
		}
	}

	return plugin.TemplatesPath
}

// Options
func (plugin *Plugin) EnabledOptions() []string {
	return plugin.Options
}

func (plugin *Plugin) EnabledOption(name string) bool {
	for _, option := range plugin.EnabledOptions() {
		if option == name {
			return true
		}
	}
	return false
}

func (plugin *Plugin) EnableOption(name string) error {
	return nil
}

func (plugin *Plugin) DisableOption(name string) error {
	return nil
}

func (*Plugin) CopyFiles(plugin PluginInterface) error {
	return copyFiles(plugin.GetTemplatesPath(), plugin.GetTheme().GetPath(), plugin.FuncMap(), plugin)
}

// Plugin Application
func (plugin *Plugin) GetTheme() ThemeInterface {
	return plugin.Theme
}

func (plugin *Plugin) SetTheme(theme ThemeInterface) {
	plugin.Theme = theme
}

// FuncMap
func (plugin *Plugin) FuncMap() template.FuncMap {
	funcMap := plugin.GetTheme().GetApplication().FuncMap()
	funcMap["has_option"] = func(options ...string) bool {
		return true
	}
	return funcMap
}
