#!/usr/bin/env ruby

# because gyp is not pefect :)

require 'xcodeproj'

module Xcodeproj
  class Project
    def recreate_user_schemes(visible = true)
      schemes_dir = XCScheme.user_data_dir(path)
      FileUtils.rm_rf(schemes_dir)
      FileUtils.mkdir_p(schemes_dir)

      xcschememanagement = {}
      xcschememanagement['SchemeUserState'] = {}
      xcschememanagement['SuppressBuildableAutocreation'] = {}

      targets.each do |target|
        scheme = XCScheme.new
        scheme.add_build_target(target)
        scheme.set_launch_target(target)
        scheme.save_as(path, target.name, false)
        xcschememanagement['SchemeUserState']["#{target.name}.xcscheme"] = {}
        xcschememanagement['SchemeUserState']["#{target.name}.xcscheme"]['isShown'] = visible
      end

      xcschememanagement_path = schemes_dir + 'xcschememanagement.plist'
      Xcodeproj.write_plist(xcschememanagement, xcschememanagement_path)
    end
  end
end


xcproj = Xcodeproj::Project.open(ARGV.shift)
xcproj.recreate_user_schemes
%w(Debug Release).each do |build_settings_name|
  build_settings = xcproj.build_settings(build_settings_name)
  build_settings['SDKROOT'] = 'iphoneos'
end
%w(Debug).each do |build_settings_name|
  build_settings = xcproj.build_settings(build_settings_name)
  build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
end
xcproj.save

