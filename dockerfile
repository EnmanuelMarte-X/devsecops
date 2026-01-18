# Stage 1: Build & Test
FROM golang:1.22-alpine AS builder

WORKDIR /app
RUN apk add --no-cache git ca-certificates

# Copiamos todo de una vez
COPY app/go.mod ./
COPY app/ ./

# UNIFICADO: Descarga, Test y Build en un solo paso para evitar que Fargate colapse
RUN go mod download && \
    go test ./... && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o vocalis-app .

# Stage 2: Runtime (Imagen final liviana)
FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /app/vocalis-app .
EXPOSE 8080
CMD ["./vocalis-app"]