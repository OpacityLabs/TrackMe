FROM golang:1.23-alpine AS builder

RUN apk add --no-cache build-base libpcap-dev
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY cmd/ ./cmd/
COPY pkg/ ./pkg/
RUN go build -o /app/trackme ./cmd/main.go

FROM alpine:3.21

RUN apk add --no-cache libpcap
WORKDIR /app

COPY --from=builder /app/trackme .
COPY static ./static/

CMD [ "./trackme" ]
