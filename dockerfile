# =========================
# Stage 1: Build + Test
# =========================
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Dependencias necesarias para go (certs, git)
RUN apk add --no-cache git ca-certificates

# 1. Corregido: Se elimina app/go.sum porque no existe en tu repo
COPY app/go.mod ./
RUN go mod download

# 2. Corregido: Copiamos el contenido de la carpeta app directamente al WORKDIR
COPY app/ ./

# Ejecutar tests (ahora están directamente en /app)
RUN go test ./...

# Compilar binario estático
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o vocalis-app .


# =========================
# Stage 2: Runtime
# =========================
# Usamos distroless por seguridad, ideal para tu formación en ciberseguridad
FROM gcr.io/distroless/base-debian12

WORKDIR /app

# 3. Corregido: Copiamos el binario desde la ruta correcta del builder
COPY --from=builder /app/vocalis-app .

EXPOSE 8080

# Ejecutar aplicación
CMD ["./vocalis-app"]