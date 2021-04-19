FROM golang:stretch as build-env

# Install minimum necessary dependencies
ENV PACKAGES curl make git libc-dev bash gcc
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y $PACKAGES

WORKDIR /dogschain
# Add source files
COPY . .

# build DogsChain
RUN make build-linux

# Final image
FROM golang:1.14 as final

WORKDIR /dogschaind
# Copy over binaries from the build-env
COPY --from=build-env /dogschain/build/dogschaind /usr/bin/dogschaind
COPY --from=build-env /dogschain/build/dogschaincli /usr/bin/dogschaincli
COPY --from=build-env /dogschain/networks/local/node/start.sh /usr/bin/start.sh

EXPOSE 26656 26657
ENTRYPOINT ["/usr/bin/start.sh"]
CMD ["start"]
STOPSIGNAL SIGTERM