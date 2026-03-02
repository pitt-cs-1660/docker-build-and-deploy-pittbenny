# STAGE 1: The Builder 
FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN go build -o pittbenny .

# STAGE 2: The Final Product
FROM scratch

WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/pittbenny .

# Tell Docker that the app listens on port 8080 
EXPOSE 8080

# Run the app
CMD ["./pittbenny"]