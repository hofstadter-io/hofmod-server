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

.PHONY: db-up
db-up:
	docker run -d --rm -it \
		--name example-db \
		-p 5432:5432 \
		-e POSTGRES_DB=example \
		-e POSTGRES_USER=example \
		-e POSTGRES_PASSWORD=example \
		-v ${PWD}/data/db:/var/lib/postgresql/data \
		postgres:13

.PHONY: db-down
db-down:
	docker rm -f example-db

.PHONY: db-clean
db-clean:
	sudo rm -rf ./data/db

.PHONY: dev-nuke
db-nuke: db-down db-clean

.PHONY: psql
psql:
	@docker run --rm -it --name psql \
		--network host \
		postgres:13 \
		psql postgresql://example:example@localhost:5432/example

.PHONY: cloc
cloc:
	cloc --read-lang-def=$$HOME/hof/jumpfiles/assets/cloc_defs.txt ./example/ ./config/ ./secret/
	cloc --read-lang-def=$$HOME/hof/jumpfiles/assets/cloc_defs.txt ./schema/ ./gen/ ./templates/ ./partials/
	cloc --read-lang-def=$$HOME/hof/jumpfiles/assets/cloc_defs.txt ./output/
