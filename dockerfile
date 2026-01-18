# Stage 1: Build & Test
FROM golang:1.22-alpine AS builder

# Instalamos lo mínimo necesario
RUN apk add --no-cache git ca-certificates

WORKDIR /app

# Copiamos archivos de dependencias
COPY app/go.mod ./
# Si llegas a tener go.sum, descomenta la línea de abajo
# COPY app/go.sum ./

# Descargamos, probamos y compilamos en UN SOLO PASO
# Esto evita que Kaniko cree "fotos" intermedias que llenan la RAM
RUN go mod download && \
    COPY app/ ./ && \
    go test ./... && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o vocalis-app .

# Stage 2: Runtime (Imagen Final)
FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /app/vocalis-app .
EXPOSE 8080
CMD ["./vocalis-app"]