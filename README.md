# sidejob

sidejob is a simple IOS app for job listings. The intent is to reduce the
friction in posting, finding, and connecting over job listings. The frontend
is written in Swift and the backend in Go.

## Backend Setup

The development environment uses `docker-compose` to bring up the web server
and the database. First, install [Docker Desktop](https://www.docker.com/products/docker-desktop/), then navigate into the
`backend` directory and run `docker-compose up --build`. This should bring up the
two services with the server running on port 8080 and the database on 5432.
Make sure that there isn't anything already listening on these ports
