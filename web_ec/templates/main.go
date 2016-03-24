package main

import (
	"fmt"
	"net/http"
)

func main() {
	var (
		mux  = http.NewServeMux()
		port = 7000
	)

	fmt.Printf("Listening on: %v\n", port)
	if err := http.ListenAndServe(fmt.Sprintf(":%d", port), mux); err != nil {
		panic(err)
	}
}
