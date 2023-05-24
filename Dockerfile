FROM golang:1.20.4-alpine3.18 as gobuilder
RUN apk add git
WORKDIR /go/src/github.com/jeanlaurent/kamoulox
COPY . ./
RUN go build .

FROM alpine:3.18.0
WORKDIR /app
COPY --from=gobuilder /go/src/github.com/jeanlaurent/kamoulox /app/
ENTRYPOINT ["./kamoulox"]
