package app

import (
	"bytes"
	"html/template"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

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

func (theme *Theme) CopyFiles(app *Application) error {
	return filepath.Walk(theme.TemplatesPath, func(path string, info os.FileInfo, err error) error {
		if err == nil {
			if info.IsDir() {
				err = os.MkdirAll(path, os.ModeDir)
			} else if info.Mode().IsRegular() {
				relativePath := strings.TrimPrefix(path, theme.TemplatesPath)
				if source, err := ioutil.ReadFile(path); err == nil {
					if filepath.Ext(path) == ".template" {
						if tmpl, err := template.New("").Funcs(app.FuncMap()).Parse(string(source)); err == nil {
							var result = bytes.NewBufferString("")
							tmpl.Execute(result, app)
							source = result.Bytes()
						}
					}
					err = ioutil.WriteFile(filepath.Join(theme.Path, strings.TrimSuffix(relativePath, ".template")), source, os.ModePerm)
				}
			}
		}
		return err
	})
}

func (theme *Theme) Build(*Application) error {
	panic("Build not implemented for Theme " + theme.Name)
}
