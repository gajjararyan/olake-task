# Build stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy Go module files
COPY go.mod go.sum ./

# Download dependencies early
RUN go mod download

# Copy the rest of the app source code
COPY . .
RUN go mod tidy

# Build the binary
RUN go build -o olake ./app && chmod +x olake


# Final lightweight image with Java 17
FROM alpine:3.18

RUN apk add --no-cache openjdk17

COPY --from=builder /app/olake /home/olake

WORKDIR /home

ENTRYPOINT ["./olake"]
