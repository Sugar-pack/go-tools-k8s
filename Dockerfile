# Start from the official Golang base image for building the app
FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the rest of the application code
COPY . .

# Install Delve (dlv) for debugging
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Build the Go application with debugging flags (disable optimizations and inlining)
RUN go build -gcflags="all=-N -l" -o main .

# Use a minimal base image to run the application. Why not scratch? Because we need the shell for debugging
FROM alpine:3.16

# Set the working directory inside the container
WORKDIR /root/

# Copy the compiled Go binary from the builder stage
COPY --from=builder /app/main .
COPY --from=builder /go/bin/dlv /usr/local/bin/dlv

# Expose the application port
EXPOSE 8080

# Expose the Delve debugging port
EXPOSE 40000

# Run Delve in headless mode to debug the Go app
CMD ["dlv", "exec", "./main", "--headless", "--listen=:40000", "--api-version=2", "--accept-multiclient", "--continue"]
