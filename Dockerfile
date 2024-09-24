FROM golang:1.23.1 AS gobuilder
WORKDIR /go/src/github.com/jeanlaurent/kamoulox
COPY . ./
RUN go build .

FROM scratch
RUN adduser -D kamouloxuser
USER kamouloxuser
WORKDIR /app
COPY --from=gobuilder /go/src/github.com/jeanlaurent/kamoulox /app/
ENTRYPOINT ["./kamoulox"]
