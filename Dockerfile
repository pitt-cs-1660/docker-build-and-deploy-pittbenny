# STAGE 1: The Builder
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy dependency files
COPY go.mod ./
RUN go mod download

# Copy the rest of the source code 
COPY . .

# Build the binary
RUN CGO_ENABLED=0 go build -o pittbenny .

# STAGE 2: The Final Product
FROM scratch

# Copy the binary from the builder
COPY --from=builder /app/pittbenny /pittbenny

# Copy the templates directory from the builder
COPY --from=builder /app/templates /templates

# Tell Docker the app uses port 8080
EXPOSE 8080

# Run the binary from the root
ENTRYPOINT ["/pittbenny"]