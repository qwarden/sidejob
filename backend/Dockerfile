# syntax=docker/dockerfile:1

FROM golang:1.21 AS build-stage

WORKDIR /api

COPY go.mod go.sum ./

RUN go mod download

COPY src/* ./

RUN CGO_ENABLED=0 GOOS=linux go build -o ./bin/sidejob-api

FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /api

COPY --from=build-stage /api/bin/sidejob-api ./bin/sidejob-api

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/api/bin/sidejob-api"]