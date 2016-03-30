package app

import (
	"bytes"
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

func isExistingDir(pth string) (string, bool) {
	if fi, err := os.Stat(pth); err == nil {
		return pth, fi.Mode().IsDir()
	}
	return "", false
}

func copyFiles(source, projectPath string, funcMap template.FuncMap, object interface{}) error {
	if source == "" {
		return nil
	}

	if projectPath == "" {
		projectPath = "."
	}

	return filepath.Walk(source, func(path string, info os.FileInfo, err error) error {
		if err == nil {
			var relativePath = strings.TrimPrefix(path, source)

			if info.IsDir() {
				err = os.MkdirAll(filepath.Join(projectPath, relativePath), os.ModePerm)
			} else if info.Mode().IsRegular() {
				var source []byte
				if source, err = ioutil.ReadFile(path); err == nil {
					if filepath.Ext(path) == ".template" {
						var tmpl *template.Template
						if tmpl, err = template.New("").Funcs(funcMap).Parse(string(source)); err == nil {
							var result = bytes.NewBufferString("")
							if err = tmpl.Execute(result, object); err != nil {
								return err
							}
							source = result.Bytes()
						} else {
							return err
						}
					}
					err = ioutil.WriteFile(filepath.Join(projectPath, strings.TrimSuffix(relativePath, ".template")), source, os.ModePerm)
				}
			}
		}
		return err
	})
}
