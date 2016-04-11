#!/bin/bash
# fully close the simulator and open the desired one
killall 'Simulator'

# launch
xcrun instruments -w 'iPhone 5s'

# build:
xcodebuild -scheme Example -workspace Example.xcworkspace -destination 'platform=iphonesimulator,name=iPhone 5s' -derivedDataPath build

# uninstall old / install new
xcrun simctl uninstall booted "Example"
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/Example.app

# run app:
xcrun simctl launch booted "Example"
