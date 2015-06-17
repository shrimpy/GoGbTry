package main
import (
    "fmt"
    "net/http"
    "os" 
)
func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "You just browsed page (if blank you're at the root): %s", r.URL.Path[1:])
}
func main() {
    port := "3001"
    if os.Getenv("HTTP_PLATFORM_PORT") != "" {
        port = os.Getenv("HTTP_PLATFORM_PORT")
    }
    
    http.HandleFunc("/", handler)
    http.ListenAndServe(":"+port, nil)
}