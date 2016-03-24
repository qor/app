package app

import (
	"os"
	"path/filepath"
	"strings"
)

type ThemeInterface interface {
	GetName() string
	GetPath() string
	CopyFiles() error
}

type Theme struct {
	Name          string
	Path          string
	TemplatesPath string
}

func (theme *Theme) CopyFiles() error {
	return filepath.Walk(theme.TemplatesPath, func(path string, info os.FileInfo, err error) (err error) {
		if info.IsDir() {
			err = os.MkdirAll(path, os.O_RDWR)
		} else if info.Mode().IsRegular() {
			relativePath := strings.TrimPrefix(path, template.TemplatesPath)
			if source, err := io.ReadFile(path); err == nil {
				err = io.WriteFile(filepath.Join(theme.Path, relativePath), source, os.O_RDWR)
			}
		}
		return
	})
}
