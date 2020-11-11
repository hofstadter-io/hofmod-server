# hofmod-rest

A Golang server generator

Components:

- Echo server framework
- GORM for database work


### Running the example

The design is in the `./example/*.cue` files.
It uses

- `hofmod-server` for a REST API and extras
- `hofmod-cli` for the binary entrypoint

##### Generate and build the server

```sh
hof mod vendor cue
make gen
make build
```

##### Database setup

```sh
# Starts Postgres 13 in docker
make dev-db-start

# Check db connection
./server db test

# Migrate the DB Schema
./server db migrate

# Seed the database
./server db seed
```

##### Run the server

```sh
# Run the example server in dev mode
./server run

# Print server config and secrets
./server config

# Print server routes
./server routes
```

##### Call the server

```sh
# bad route(s)
curl localhost:1323              // not found  (404)

# unauth'd sample route
curl localhost:1323/echo?msg=... // msg...     (200)
curl localhost:1323/echo/msg     // msg...     (200)

# test auth
curl -u 'admin@example.com:admin-pass' localhost:1323/auth/test  // OK (200)
curl -h 'apikey: 953e7caf-1fa6-4558-a693-4118fce9615e' localhost:1323/auth/test  // OK (200)

# alive & metrics
curl <auth> localhost:1323/internal/alive    // no content (200)
curl <auth> localhost:1323/internal/metrics  // prometheus metrics

# sample auth'd routes
curl <auth> localhost:1323/hello                    // hello <name> (200)
curl <auth> localhost:1323/hello/world[?msg=...]    // hello <name or msg> (200)
```
