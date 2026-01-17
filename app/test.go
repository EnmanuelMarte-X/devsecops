package main

import (
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("hello"))
}

func health(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("ok"))
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/health", health)

	http.ListenAndServe(":8080", nil)
}
