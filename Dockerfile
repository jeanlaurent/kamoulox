FROM golang:1.8.3-alpine as gobuilder
WORKDIR /go/src/github.com/jeanlaurent/kamoulox
COPY . ./
RUN go build -o kamoulox ./

FROM alpine:3.6
WORKDIR /app
RUN apk add --no-cache ca-certificates
COPY --from=gobuilder /go/src/github.com/kamoulox/kamoulox /app/
ENTRYPOINT ["./kamoulox"]
