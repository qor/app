package app

import (
	"bytes"
	"fmt"
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
	CopyFiles(*Application) error
	Build(*Application) error
}

type Theme struct {
	Name          string
	Path          string
	TemplatesPath string
}

func (theme *Theme) GetName() string {
	return theme.Name
}

func isExistingDir(pth string) (string, bool) {
	if fi, err := os.Stat(pth); err == nil {
		return pth, fi.Mode().IsDir()
	}
	return "", false
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

func (theme *Theme) CopyFiles(app *Application) error {
	templatesPath := theme.GetTemplatesPath()
	return filepath.Walk(templatesPath, func(path string, info os.FileInfo, err error) error {
		fmt.Println(path)
		fmt.Println(err)
		if err == nil {
			var projectPath = theme.Path
			var relativePath = strings.TrimPrefix(path, templatesPath)

			if projectPath == "" {
				projectPath = "."
			}

			if info.IsDir() {
				err = os.MkdirAll(filepath.Join(projectPath, relativePath), os.ModePerm)
			} else if info.Mode().IsRegular() {
				var source []byte
				if source, err = ioutil.ReadFile(path); err == nil {
					fmt.Println(source)
					if filepath.Ext(path) == ".template" {
						var tmpl *template.Template
						if tmpl, err = template.New("").Funcs(app.FuncMap()).Parse(string(source)); err == nil {
							var result = bytes.NewBufferString("")
							tmpl.Execute(result, app)
							source = result.Bytes()
						}
					}
					err = ioutil.WriteFile(filepath.Join(projectPath, strings.TrimSuffix(relativePath, ".template")), source, os.ModePerm)
				}
			}
		}
		fmt.Println(err)
		return err
	})
}

func (theme *Theme) Build(*Application) error {
	panic("Build not implemented for Theme " + theme.Name)
}
