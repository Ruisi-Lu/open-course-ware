FROM golang:1.18

WORKDIR /go/src
COPY main.go .
COPY go.mod .
ENV CGO_ENABLED=0
RUN go get -d -v ./...
RUN go build -a -installsuffix cgo -o main .
EXPOSE 8080/tcp
ENTRYPOINT ["./main"]