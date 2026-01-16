# Stage 1: build + test
FROM golang:1.22-alpine AS builder
WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .
RUN go test ./...
RUN go build -o app

# Stage 2: runtime
FROM alpine:latest
WORKDIR /app

COPY --from=builder /app/app .
EXPOSE 8080

CMD ["./app"]


sss
