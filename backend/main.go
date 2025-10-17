package main

import (
    "encoding/json"
    "log"
    "net/http"
    "os"
)

func main() {
    mux := http.NewServeMux()

    mux.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte("ok"))
    })

    mux.HandleFunc("/api/hello", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w, r)
        if r.Method == http.MethodOptions {
            w.WriteHeader(http.StatusNoContent)
            return
        }
        w.Header().Set("Content-Type", "application/json; charset=utf-8")
        json.NewEncoder(w).Encode(map[string]string{"message": "Hola desde Go 👋"})
    })

    // CORS preflight para cualquier ruta /api/
    mux.HandleFunc("/api/", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w, r)
        if r.Method == http.MethodOptions {
            w.WriteHeader(http.StatusNoContent)
            return
        }
        http.NotFound(w, r)
    })

    port := os.Getenv("PORT")
    if port == "" { port = "8080" }

    log.Printf("Backend escuchando en :%s", port)
    if err := http.ListenAndServe(":"+port, logMiddleware(mux)); err != nil {
        log.Fatal(err)
    }
}

func enableCORS(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Access-Control-Allow-Origin", "*")
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
}

func logMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s", r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}