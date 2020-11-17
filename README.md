# hofmod-server

A Golang server generator where you can write
custom code in the output while evolving the design.

Built with [hof](https://github.com/hofstadter-io/hof) - the high code generator framework.

### Features

See the [schema](./schema) for designing details,
you can customize just about everything.

#### REST Server

- Entity framework (builtin users and groups)
- Password and APIKey authentication
- Role base authorization
- Account management handlers (register, confirm, disable)
- Email system and customizable templates
- Extensible route definitions
- Embedded static resources
- Setup for separate config & sercrets across multiple environments
- Kubernetes ready (prometheus and k8s manifests)
- Testing for endpoint and user sequences
- Builtin CLI with many helpful commands
- Goreleaser for simplified releases

#### Data Model

- Automated schema generation and incremental migrations
- Server sub-commands for database migrations seeding
- Extensible data model for defining resources
- Default resource CRUD handlers, customizable
- Define your own defaults for resources

### Running the example

The design is in the `./example/*.cue` files.
It uses

- `hofmod-server` for a REST API and extras
- `hofmod-cli` for the binary entrypoint

##### Generate and build the server

```sh
hof mod vendor
make gen
make build
```

##### Database setup

```sh
# Starts Postgres 13 in docker
make db-up

# Check db connection
./server db test

# Migrate the DB Schema
./server db migrate

# Seed the database
./server db seed

# Run the PSQL repl
make psql

# Stop the database
make db-down

# Destroy the database
make db-nuke
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
