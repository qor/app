package app

type PluginInterface interface {
	EnableOption(name string) error
	DisableOption(name string) error
	EnabledOptions() []string
	EnabledOption(name string) bool
	CopyFiles(PluginInterface) error // copy files for web, android, ios
}

type Plugin struct {
	Options []string
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
