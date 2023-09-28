FROM hexpm/elixir:1.14.3-erlang-25.3-alpine-3.15.7 AS build
RUN apk add --no-cache git build-base curl gcompat
RUN curl -o sodium.tgz https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
RUN tar xvzf sodium.tgz && cd libsodium-stable && ./configure && make && make install

WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force
COPY . .
RUN mix deps.get && mix compile
RUN mix test

# FROM alpine:3.15.7 AS app
# RUN apk add --no-cache libsodium
# WORKDIR /app
# COPY --from=build /app/_build/prod/rel/fly ./
# COPY scripts/docker-boot.sh docker-boot.sh
