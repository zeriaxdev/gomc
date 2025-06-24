package main

import (
	"log"
	"net/http"
	"os"
	"path/filepath"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000" // Default port
	}

	// Serve static files from the 'web' directory
	fs := http.FileServer(http.Dir("./web"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	// Handle the root path to serve index.html
	http.HandleFunc("/", serveIndex)

	log.Printf("Server starting on port %s\n", port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

// serveIndex serves the index.html file.
func serveIndex(w http.ResponseWriter, r *http.Request) {
	// Ensure only the root path serves index.html
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	indexPath := filepath.Join("web", "index.html")
	http.ServeFile(w, r, indexPath)
}
