FROM golang:1.18.1-alpine3.15@sha256:42d35674864fbb577594b60b84ddfba1be52b4d4298c961b46ba95e9fb4712e8 as gobuilder
RUN apk add git
WORKDIR /go/src/github.com/jeanlaurent/kamoulox
COPY . ./
RUN go build .

FROM alpine:3.15@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454
WORKDIR /app
COPY --from=gobuilder /go/src/github.com/jeanlaurent/kamoulox /app/
ENTRYPOINT ["./kamoulox"]
