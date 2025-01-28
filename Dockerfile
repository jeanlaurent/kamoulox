FROM golang:1.23.4-alpine AS gobuilder
WORKDIR /src
COPY go.mod ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download
COPY . /src/
RUN --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/go/pkg/mod \
    go build -o kamoulox cmd/kamoulox/*.go

FROM scratch
WORKDIR /app
COPY --from=gobuilder /src/kamoulox /app/
ENTRYPOINT ["./kamoulox"]