FROM golang:1.19-alpine as gobuilder
RUN apk add git
WORKDIR /go/src/github.com/jeanlaurent/kamoulox
COPY . ./
RUN go build .

FROM alpine:3.17.2
WORKDIR /app
COPY --from=gobuilder /go/src/github.com/jeanlaurent/kamoulox /app/
ENTRYPOINT ["./kamoulox"]
