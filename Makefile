.PHONY: help
help:
	@cat Makefile
	@echo "no arg supplied"

.PHONY: server
server: gen build

.PHONY: gen
gen:
	@hof gen ./example/

.PHONY: build
build:
	@go build -o server ./output/cmd/example/

.PHONY: clean
clean:
	rm -rf ./.hof/ ./output/ server

.PHONY: dev-db-start
dev-db-start:
	docker run -d --rm -it \
		--name example-db \
		-p 5432:5432 \
		-e POSTGRES_DB=example \
		-e POSTGRES_USER=example \
		-e POSTGRES_PASSWORD=example \
		-v $(pwd)/data/db:/var/lib/postgresql/data \
		postgres:13

.PHONY: dev-db-stop
dev-db-stop:
	docker rm -f example-db

.PHONY: dev-db-clean
dev-db-clean: dev-db-stop
	rm -rf ./data/db

.PHONY: dev-db-psql
dev-db-psql:
	@psql postgresql://example:example@localhost:5432/example
