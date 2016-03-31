package main

import (
	"fmt"
	"net/http"

	"github.com/qor/qor-example/config/routes"
)

func main() {
	var (
		mux  = http.NewServeMux()
		port = 7000
	)

	mux.Handle("/", routes.Router())

	fmt.Printf("Listening on: %v\n", port)
	if err := http.ListenAndServe(fmt.Sprintf(":%d", port), mux); err != nil {
		panic(err)
	}
}
