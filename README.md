# hofmod-rest

A Golang server generator

Components:

- Echo server framework
- GORM for database work


### Running the example

The design is in the `./example/*.cue` files.
It uses

- `hofmod-server` for a REST API
- `hofmod-cli` for the binary entrypoint
- `hofmod-model` for modeling resources

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
./server db seed seeds/all.cue
```

##### Run the server

```sh
# Run the server
./server serve
```

##### Call the server

```sh
curl localhost:1323          // not found  (404)
curl localhost:1323/alive    // no content (200)
curl localhost:1323/metrics  // prometheus metrics
```
