package main

import (
	"github.com/qor/app"
	"github.com/qor/app/web_ec"
)

func main() {
	Application := app.New("Qor Demo")
	Application.Use(&web_ec.EC{})
	Application.Use(&ios_ec.EC{})
	Application.Create()
}
