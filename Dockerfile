# STAGE 1: The Builder
FROM golang:1.23-alpine AS builder

# These environment variables ensure the binary is "static" and works in 'scratch'
ENV CGO_ENABLED=0 
ENV GOOS=linux

WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .

# Build the binary with flags that make it completely self-sufficient
RUN go build -a -installsuffix cgo -o pittbenny .

# STAGE 2: The Final Product
FROM scratch

# Copy the binary from the builder
COPY --from=builder /app/pittbenny /pittbenny

# Tell Docker the app uses port 8080
EXPOSE 8080

# Run the binary from the root
ENTRYPOINT ["/pittbenny"]