# Simple usage with a mounted data directory:
# > docker build -t dogschain .
# > docker run -it -p 36657:36657 -p 36656:36656 -v ~/.dogschaind:/root/.dogschaind -v ~/.dogschaincli:/root/.dogschaincli dogschain dogschaind init mynode
# > docker run -it -p 36657:36657 -p 36656:36656 -v ~/.dogschaind:/root/.dogschaind -v ~/.dogschaincli:/root/.dogschaincli dogschain dogschaind start
FROM golang:alpine AS build-env

# Install minimum necessary dependencies, remove packages
RUN apk add --no-cache curl make git libc-dev bash gcc linux-headers eudev-dev

# Set working directory for the build
WORKDIR /go/src/github.com/dogschain/dogschain

# Add source files
COPY . .

# Build DogsChain
RUN GOPROXY=http://goproxy.cn make install

# Final image
FROM alpine:edge

WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /go/bin/dogschaind /usr/bin/dogschaind
COPY --from=build-env /go/bin/dogschaincli /usr/bin/dogschaincli

# Run okexchaind by default, omit entrypoint to ease using container with dogschaincli
CMD ["dogschaind"]