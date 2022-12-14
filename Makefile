ifndef LIGO
	LIGO = docker run --rm -v "${PWD}":"${PWD}" -w "${PWD}" ligolang/ligo:0.57.0
endif

default: help

compile = $(LIGO) compile contract ./src/contracts/$(1) -o ./src/compiled/$(2)
testing = $(LIGO) run test ./tests/$(1)

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
	@echo "Compiling contract... Done"

clean:
	@echo "Cleaning..."
	@rm -rf ./src/compiled/*
	@echo "Cleaning... Done"

test: test-ligo test-integration

test-ligo:
	@echo "Testing contracts..."
	@$(call testing,increment.test.mligo)
	@$(call testing,decrement.test.mligo)
	@echo "Testing... Done"

test-integration:
	@echo "Test integration comming soon..."
