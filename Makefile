.PHONY: test build clean help

# Default target
help:
	@echo "Available commands:"
	@echo "  make test    - Run all tests"
	@echo "  make build   - Build Docker image"
	@echo "  make clean   - Clean up test containers and volumes"
	@echo "  make help    - Show this help message"

# Build the Docker image
build:
	@echo "🏗️  Building Docker image..."
	@docker compose -f tests/compose.test.yaml build

# Run all tests
test: build
	@echo "🧪 Running tests..."
	@cd tests && ./test.sh

# Clean up test environment
clean:
	@echo "🧹 Cleaning up test environment..."
	@docker compose -f tests/compose.test.yaml down -v --remove-orphans 2>/dev/null || true
	@docker system prune -f 2>/dev/null || true
	@echo "✅ Cleanup complete"

# Quick test specific scenarios
test-default:
	@echo "🧪 Testing default behavior only..."
	@docker compose -f tests/compose.test.yaml up -d test-default
	@sleep 15
	@curl -f http://localhost:8090/api/health && echo "✅ Default test passed" || echo "❌ Default test failed"
	@docker compose -f tests/compose.test.yaml down

test-env:
	@echo "🧪 Testing environment variables only..."
	@docker compose -f tests/compose.test.yaml up -d test-custom-env
	@sleep 15
	@curl -f http://localhost:9090/api/health && echo "✅ Environment test passed" || echo "❌ Environment test failed"
	@docker compose -f tests/compose.test.yaml down
