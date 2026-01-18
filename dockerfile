# =========================
# Stage 1: Build + Test
# =========================
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Dependencias necesarias para go (certs, git)
RUN apk add --no-cache git ca-certificates

# Copiar archivos de dependencias
COPY app/go.mod app/go.sum ./
RUN go mod download

# Copiar código fuente
COPY app ./app
WORKDIR /app/app

# Ejecutar tests
RUN go test ./...

# Compilar binario estático
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app


# =========================
# Stage 2: Runtime
# =========================
FROM gcr.io/distroless/base-debian12

WORKDIR /app

# Copiar binario desde el builder
COPY --from=builder /app/app/app .

EXPOSE 8080

# Ejecutar aplicación
CMD ["./app"]


