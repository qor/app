{
	"target_defaults": {
		"default_configuration": "Debug",
		"configurations": {
			"Debug": {
				"xcode_settings": {
					"ONLY_ACTIVE_ARCH": "YES"
				},
				"defines": ["$(inherited)", "DEBUG", "_DEBUG"]
			},
			"Release": {
				"defines": ["$(inherited)", "NDEBUG"]
			}
		}
	},
	"targets": [{
		"target_name": "example",
		"type": "executable",
		"mac_bundle": 1,
		"include_dirs": ["substructure"],
		"sources": ["<!@(sh scripts/list-source-files.sh)"],
		"mac_bundle_resources": ["<!@(sh scripts/list-resource-files.sh)"],
		"link_settings": {
			"libraries": []
		},
		"xcode_settings": {
			"INFOPLIST_FILE": "src/Info.plist",
			"SDKROOT": "iphoneos",
			"TARGETED_DEVICE_FAMILY": "1,2",
			"CODE_SIGN_IDENTITY": "iPhone Developer",
			"IPHONEOS_DEPLOYMENT_TARGET": "9.0",
			"HEADER_SEARCH_PATHS": "$(inherited)",
			"CLANG_ENABLE_OBJC_ARC": "YES",
			"CLANG_ENABLE_MODULES": "YES",
			"LD_RUNPATH_SEARCH_PATHS": "$(inherited) @executable_path/Frameworks"
		}
	}]
}
