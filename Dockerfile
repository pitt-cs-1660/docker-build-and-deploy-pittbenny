# STAGE 1: The Builder
# We use a heavy image that has all the Go tools installed to compile the code.
FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the dependency files first (this makes builds faster)
COPY go.mod ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Compile the application into a single binary file named "pittbenny"
RUN go build -o pittbenny .

# STAGE 2: The Final Product
# We switch to a tiny, "distroless" image that only contains the bare essentials to run the app.
FROM alpine:latest

WORKDIR /root/

# We only copy the finished "pittbenny" binary from the builder stage.
# We leave behind all the source code and Go compilers!
COPY --from=builder /app/pittbenny .

# Tell the container to run the app when it starts
CMD ["./pittbenny"]