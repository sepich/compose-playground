FROM golang:1.23.2 AS build
WORKDIR /go/src/app
COPY go.mod .
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /go/bin/app

FROM alpine

COPY --from=build /go/bin/app /
CMD ["/app"]
