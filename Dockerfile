FROM golang:1.18.1-alpine3.15@sha256:42d35674864fbb577594b60b84ddfba1be52b4d4298c961b46ba95e9fb4712e8 as gobuilder
RUN apk add git
WORKDIR /go/src/github.com/jeanlaurent/kamoulox
COPY . ./
RUN go build .

FROM alpine:3.15@sha256:69463fdff1f025c908939e86d4714b4d5518776954ca627cbeff4c74bcea5b22
WORKDIR /app
COPY --from=gobuilder /go/src/github.com/jeanlaurent/kamoulox /app/
ENTRYPOINT ["./kamoulox"]
