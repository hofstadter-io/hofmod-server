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
```

##### Call the server

```sh
curl localhost:1323          // not found  (404)
curl localhost:1323/alive    // no content (200)
curl localhost:1323/metrics  // prometheus metrics

# test auth
curl -u 'admin@example.com:admin-pass' localhost:1323/auth/test  // OK (200)
```
