package ios_ec

import "github.com/qor/app"
import "os"
import "os/exec"

type EC struct {
	app.Theme
	Path string
}

func (ec *EC) GetTemplatesPath() string {
	if ec.TemplatesPath == "" {
		ec.TemplatesPath = "github.com/qor/app/ios_ec/templates"
	}
	return ec.Theme.GetTemplatesPath()
}

func (ec *EC) ConfigureQorTheme(theme app.ThemeInterface) {
	ec.Theme.Path = ec.Path
	return
}

func (ec *EC) Build(theme app.ThemeInterface) error {
	pwd, _ := os.Getwd() 
	os.Chdir("iOS/Temp")

	//config ios project name, app icons, certificates and so on...
	exec.Command("./configProj.rb").Run()

	//generate Xcode project, install third-party libs and so on...
	exec.Command("make","all").Run()

	os.Chdir(pwd)

	return nil
}
