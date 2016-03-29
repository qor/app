package app

import (
	"bytes"
	"errors"
	"html/template"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

var root = "."

func init() {
	if path := os.Getenv("WEB_ROOT"); path != "" {
		root = path
	}
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
	GetPlugin(name string) PluginInterface
}

type Theme struct {
	Name          string
	Path          string
	TemplatesPath string
	Application   *Application
}

func (theme *Theme) UsePlugin(plugin PluginInterface) {
}

func (theme *Theme) GetPlugin(name string) PluginInterface {
}

func (theme *Theme) GetName() string {
	return theme.Name
}

func (theme *Theme) GetPath() string {
	return theme.Path
}

func (theme *Theme) GetTemplatesPath() string {
	if pth, ok := isExistingDir(filepath.Join(root, "vendor", theme.TemplatesPath)); ok {
		return pth
	}

	for _, gopath := range strings.Split(os.Getenv("GOPATH"), ":") {
		if pth, ok := isExistingDir(filepath.Join(gopath, "src", theme.TemplatesPath)); ok {
			return pth
		}
	}

	return theme.TemplatesPath
}

// Patch model, functions (golang, java, swift)
func (*Theme) CopyFiles(theme ThemeInterface) error {
	templatesPath := theme.GetTemplatesPath()
	return filepath.Walk(templatesPath, func(path string, info os.FileInfo, err error) error {
		if err == nil {
			var projectPath = theme.GetPath()
			var relativePath = strings.TrimPrefix(path, templatesPath)

			if projectPath == "" {
				projectPath = "."
			}

			if info.IsDir() {
				err = os.MkdirAll(filepath.Join(projectPath, relativePath), os.ModePerm)
			} else if info.Mode().IsRegular() {
				var source []byte
				if source, err = ioutil.ReadFile(path); err == nil {
					if filepath.Ext(path) == ".template" {
						var tmpl *template.Template
						if tmpl, err = template.New("").Funcs(theme.GetApplication().FuncMap()).Parse(string(source)); err == nil {
							var result = bytes.NewBufferString("")
							tmpl.Execute(result, theme)
							source = result.Bytes()
						}
					}
					err = ioutil.WriteFile(filepath.Join(projectPath, strings.TrimSuffix(relativePath, ".template")), source, os.ModePerm)
				}
			}
		}
		return err
	})
}

func (*Theme) Build(theme ThemeInterface) error {
	return errors.New("Build not implemented for Theme " + theme.GetName())
}

func (theme *Theme) GetApplication() *Application {
	return theme.Application
}

func (theme *Theme) SetApplication(app *Application) {
	theme.Application = app
}

func isExistingDir(pth string) (string, bool) {
	if fi, err := os.Stat(pth); err == nil {
		return pth, fi.Mode().IsDir()
	}
	return "", false
}
