# syntax=docker/dockerfile:1

FROM golang:1.21 AS build-stage

WORKDIR /

COPY . . 

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -o ./bin/api

FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /

COPY --from=build-stage /bin/api ./bin/api

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/bin/api"]
