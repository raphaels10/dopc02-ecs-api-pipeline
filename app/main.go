package main

import (
	"fmt"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintln(w, `{"message":"Hello World from v2!"}`)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, `{"status":"ok"}`)
}

func main() {
	http.HandleFunc("/", helloHandler)
	http.HandleFunc("/health", healthHandler)

	fmt.Println("Server running on http://0.0.0.0:80")
	if err := http.ListenAndServe(":80", nil); err != nil {
		panic(err)
	}
}
