package app

import (
	"errors"
	"html/template"
	"os"
	"path/filepath"
	"reflect"
	"strings"
)

type ConfigureQorPluginInterface interface {
	ConfigureQorPlugin(PluginInterface)
}

type PluginInterface interface {
	Initialize(PluginInterface)
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

func (plugin *Plugin) Initialize(p PluginInterface) {
	if p.GetName() == "" {
		plugin.Name = reflect.ValueOf(p).Elem().Type().Name()
	}

	if p.GetTemplatesPath() == "" {
		plugin.TemplatesPath = filepath.Join(reflect.ValueOf(p).Elem().Type().PkgPath(), "templates")
	}
}

func (plugin *Plugin) GetName() string {
	return plugin.Name
}

func (plugin *Plugin) ConfigureQorPlugin(p PluginInterface) {
	if plugin.GetName() == "" {
		plugin.Name = reflect.ValueOf(p).Elem().Type().Name()
	}
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
	plugin.Options = append(plugin.Options, name)
	return nil
}

func (plugin *Plugin) DisableOption(name string) (err error) {
	var found bool
	var options []string

	for _, option := range plugin.Options {
		if name != option {
			options = append(options, option)
		} else {
			found = true
		}
	}
	plugin.Options = options

	if found {
		return nil
	}
	return errors.New("option not enabled")
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
	funcMap := plugin.GetTheme().FuncMap()
	funcMap["has_option"] = func(name string) bool {
		for _, option := range plugin.EnabledOptions() {
			if option == name {
				return true
			}
		}
		return false
	}
	return funcMap
}
