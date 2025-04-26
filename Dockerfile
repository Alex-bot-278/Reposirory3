# Этап сборки
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Копируем зависимости и исходники
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Компилируем приложение
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/tracker .

# Этап запуска
FROM alpine:latest

WORKDIR /app

# Копируем бинарник и файл БД (если нужно)
COPY --from=builder /app/tracker /app/tracker
COPY --from=builder /app/tracker.db /app/tracker.db  # (если есть начальная БД)

# Указываем команду для запуска
CMD ["/app/tracker"]