FROM golang:1.18 AS build
WORKDIR /go/src
COPY main.go .
COPY go.mod .
ENV CGO_ENABLED=0
RUN go get -d -v ./...
RUN go build -a -installsuffix cgo -o main .

FROM scratch AS runtime
WORKDIR /app
COPY --from=build /go/src/main ./
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
EXPOSE 8080/tcp
ENTRYPOINT ["./main"]