# ---------- STAGE 1: BUILD ----------
FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY app/ .

RUN go build -o app

# ---------- STAGE 2: RUNTIME ----------
FROM alpine:3.19

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
