package main

import (
	"context"
	"fmt"
	"net/http"
	"os"

	"github.com/go-redis/redis/v8"
)

var rdb *redis.Client
var ctx = context.Background()

func init() {
	// To adapt the app to any network configuration
	redisURL := os.Getenv("REDIS_URL")
	if redisURL == "" {
		redisURL = "localhost:6379"
	}
	rdb = redis.NewClient(&redis.Options{
		Addr: redisURL, // Redis server address
	})
}

func hello(w http.ResponseWriter, r *http.Request) {
	incr := rdb.Incr(ctx, "counter")
	count, err := incr.Result()
	if err != nil {
		http.Error(w, "Error incrementing counter", http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, "hello, my name is Falcon. You've visited %d times!", count)
}

func main() {
	http.HandleFunc("/", hello)
	port := ":4000"
	fmt.Println("Server running at http://localhost" + port)
	http.ListenAndServe(port, nil)
}
