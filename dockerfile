# Stage 1: build + test
FROM golang:1.22-alpine AS builder
WORKDIR /app

# Copiar go.mod desde la raíz
COPY go.mod ./

RUN go mod download

# Copiar solo el contenido de app
COPY app ./app

WORKDIR /app/app

RUN go test ./...
RUN go build -o /app/app/app

# Stage 2: runtime
FROM alpine:latest
WORKDIR /app

COPY --from=builder /app/app/app ./
EXPOSE 8080

CMD ["./app"]
