FROM golang:1.19

# Set destination for COPY
WORKDIR /app

# Install `make`
RUN apt update && apt install make && rm -rf /var/lib/apt/lists/*

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY ./ ./

# Build
# Example simple build: RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping
# In `Makefile`: build release release-windows
RUN make release && make release-windows

# Run
# CMD ["/docker-gs-ping"]