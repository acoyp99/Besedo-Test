FROM --platform=linux/amd64 golang:1.19

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /backend
EXPOSE 4000

CMD ["/backend"]