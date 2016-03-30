package app

type PluginInterface interface {
	GetName() string
	EnableOption(name string) error
	DisableOption(name string) error
	EnabledOptions() []string
	EnabledOption(name string) bool
	CopyFiles(PluginInterface) error // copy files for web, android, ios
}

type Plugin struct {
	Name    string
	Options []string
}

func (plugin *Plugin) GetName() string {
	return plugin.Name
}

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

func (plugin *Plugin) CopyFiles(PluginInterface) error {
	return nil
}
