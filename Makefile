.PHONY: help
help:
	@cat Makefile
	@echo "no arg supplied"

.PHONY: gen
gen:
	@hof gen ./example/

.PHONY: build
build:
	@go build -o server ./output/cmd/example/
