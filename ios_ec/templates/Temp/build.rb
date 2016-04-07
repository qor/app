#!/usr/bin/env ruby

require 'json'

config_file = File.read('config.json')
data_hash = JSON.parse(config_file)

# modify .gyp file
product_name = data_hash["product_name"]
company_name = data_hash["company_name"]

gyp_file = File.read('temp.gyp')

gyp_hash = JSON.parse(gyp_file)

gyp_hash["targets"][0]["target_name"] = product_name

File.open(product_name + '.gyp', "w") do |f|
    f << gyp_hash.to_json
end

#File.rename('temp.gyp', product_name + '.gyp')

# modify make file
lines = []

File.foreach('Makefile').with_index do |line, line_num|
	if line_num == 3 
		lines << "	gyp #{product_name}.gyp --depth=. -f xcode -DOS=ios\n"
	elsif line_num == 4
		lines << "	ruby scripts/fix-project.rb #{product_name}.xcodeproj\n"
	else
		lines << line
	end	
end

File.open('Makefile', "w") do |f|
    lines.each do |line|
    	f << line
    end
end

# modify podfile
lines = []

File.foreach('Podfile').with_index do |line, line_num|
	if line_num == 0 
		lines << "target '#{product_name}' do\n"
	else
		lines << line
	end	
end

File.open('Podfile', "w") do |f|
    lines.each do |line|
    	f << line
    end
end

# modify run bash file
lines = []

File.foreach('runSimulator.sh').with_index do |line, line_num|
	if line_num == 8 
		lines << "xcodebuild -scheme #{product_name} -workspace #{product_name}.xcworkspace -destination 'platform=iphonesimulator,name=iPhone 5s' -derivedDataPath build\n"
	elsif line_num == 11
		lines << "xcrun simctl uninstall booted \"#{product_name}\"\n"
	elsif line_num == 12
		lines << "xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/#{product_name}.app\n"
	elsif line_num == 15
		lines << "xcrun simctl launch booted \"#{product_name}\"\n"
	else
		lines << line
	end	
end

File.open('runSimulator.sh', "w") do |f|
    lines.each do |line|
    	f << line
    end
end

system("make all")
