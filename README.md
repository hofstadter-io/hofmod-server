# hofmod-rest

A Golang server genarator

Components:

- Echo server framework
- GORM for database work


### Running the example

The design is in the `./example/*.cue` files.
It uses

- this generator for the server
- `hofmod-cli` for the binary entrypoint
- `hofmod-cuefig` for server configuration

##### Generate the server

```sh
hof mod vendor cue
hof gen ./example
```

##### Build and run the server

```sh
go build -o ex ./example/cmd/example/
./ex serve
```

##### Call the server

```sh
curl localhost:1323          // not found  (404)
curl localhost:1323/alive    // no content (200)
curl localhost:1323/metrics  // prometheus metrics
```
