package app

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
