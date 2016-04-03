# Qor Application Generator - for DEMO

Qor Application Generator

## Usage

```sh
# Prepare ENV
cd $GOPATH/src/github.com/qor
git clone git@github.com:theplant/qor-app-generator.git
mv qor-app-generator app

# Generate Applications
cd $GOPATH/src/github.com/qor/app/example
go run application.go

# Run WEB
go run main.go

# Run iOS
cd $GOPATH/src/github.com/qor/app/example/iOS/QorDemo
open iOS/QorDemo/QorDemo.xcworkspace
```

## License

Released under the [MIT License](http://opensource.org/licenses/MIT).
