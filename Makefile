.PHONY: dev start build test clean fmt check migrate help

# Development server dengan hot reload (butuh cargo-watch: cargo install cargo-watch)
dev:
	cargo watch -c -x run

# Production server
start:
	cargo run --release

# Build production binary
build:
	cargo build --release

# Build development binary
build-dev:
	cargo build

# Run tests
test:
	cargo test

# Run tests dengan output lengkap
test-verbose:
	cargo test -- --nocapture

# Format code
fmt:
	cargo fmt

# Check code tanpa compile
check:
	cargo check

# Clean build artifacts
clean:
	cargo clean

# Run database migrations (jika diperlukan manual)
migrate:
	sqlx migrate run

# Show available commands
help:
	@echo "Available commands:"
	@echo "  make dev           - Run development server with hot reload"
	@echo "  make start         - Run production server"
	@echo "  make build         - Build production binary"
	@echo "  make build-dev     - Build development binary"
	@echo "  make test          - Run tests"
	@echo "  make test-verbose  - Run tests with full output"
	@echo "  make fmt           - Format code"
	@echo "  make check         - Check code without compiling"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make migrate       - Run database migrations"
	@echo "  make help          - Show this help message"
