all: clean gyp pods

gyp:
	gyp Example.gyp --depth=. -f xcode -DOS=ios
	ruby scripts/fix-project.rb Example.xcodeproj

pods:
	bundle install
	bundle exec pod install

clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/
	rm -rf Podfile.lock
	rm -rf Pods
	rm -rf *.xc*
	rm -rf build/
