# Qor Application Generator - for DEMO

Qor Application Generator

## Usage

```sh
# Prepare ENV
cd $GOPATH/src/github.com/qor
git clone git@github.com:qor/app.git

# Install GYP meta building system if you wants to generate iOS projects
brew tap mgamer/homebrew-taps
brew install gyp

# Generate Applications
cd $GOPATH/src/github.com/qor/app/example
go run application.go

# Run WEB
cd $GOPATH/src/github.com/qor/app/example
go run main.go

# before run iOS demo, ensure you have Xcode command line tools installed
xcode-select --install
# Run iOS, you may need to wait about 2 minutes for compiling and installing the app
cd $GOPATH/src/github.com/qor/app/example/iOS/example
./runSimulator.sh
```

## License

Released under the [MIT License](http://opensource.org/licenses/MIT).
