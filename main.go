package main

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/upload", fileUploadHandler)

	fmt.Println("server running on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func fileUploadHandler(w http.ResponseWriter, r *http.Request) {
	// Read the input
	f, err := os.Create("./uploaded")
	if err != nil {
		log.Printf("error creating file: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer f.Close()

	buf := make([]byte, 1024)
	n, err := r.Body.Read(buf)
	log.Printf("read %d bytes", n)
	if err != nil {
		log.Printf("error reading request body: %v", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// reply with Auth error without reading the body
	//http.Error(w, "", http.StatusUnauthorized) // work
	//return

	//w.Header().Set("Content-Length", "3946") // Not "chunked" encoding works
	//_, err = w.Write(bytes.Repeat([]byte("a"), 3940)) // work
	//_, err = w.Write(bytes.Repeat([]byte("a"), 3946)) // doesn't work
	n, err = w.Write(bytes.Repeat([]byte("a"), 1000000)) // doesn't work

	if err != nil {
		log.Printf("failed to write: %v\n", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	log.Printf("done\n")
	return
}
