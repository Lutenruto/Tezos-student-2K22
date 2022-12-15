ifndef LIGO
	LIGO = docker run --rm -v "${PWD}":"${PWD}" -w "${PWD}" ligolang/ligo:0.57.0
endif

compile = $(LIGO) compile contract ./src/contracts/$(1) -o ./src/compiled/$(2) $(3)
testing = $(LIGO) run test ./tests/$(1)

default: help

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  compile - Compile the contract"
	@echo "  test    - Test contracts scenarios"
	@echo "  clean   - Clean the compiled files"

compile:
	@echo "Compiling contract..."
	@$(call compile,main.mligo,main.tz)
	@$(call compile,main.mligo,main.json,--michelson-format json)
	@echo "Compiling contract... Done"

test: test-ligo test-integration

test-ligo:
	@echo "Testing contracts..."
	@$(call testing,increment.test.mligo)
	@$(call testing,decrement.test.mligo)
	@echo "Testing... Done"

test-integration:
	@echo "Test integration comming soon..."

deploy-contract:
	@echo "Deploying Main contract..."
	@npm run deploy
	@echo "Deploying... Done"

clean:
	@echo "Cleaning..."
	@rm -rf ./src/compiled/*
	@echo "Cleaning... Done"

sandbox-start:
	@./scripts/run-sandbox.sh

sandbox-stop:
	@docker stop sandbox