# Mi App (Go + React)


- Backend: Go (net/http)
- Frontend: React + Vite
- Docker: Dockerfiles + docker-compose


## Dev sin Docker
```bash
# Backend
cd backend && go run main.go
# Frontend
cd frontend && npm install && npm run dev

## Con Docker Compose

docker compose up --build

Frontend: http://localhost:5173

Backend: http://localhost:8080