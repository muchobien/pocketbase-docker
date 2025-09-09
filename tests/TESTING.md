# Testing Documentation

This document describes the testing setup for the PocketBase Docker image.

## Test Coverage

The test suite covers all implemented features with **8 comprehensive tests**:

### 1. Default Server Behavior

- **Test**: Container starts with default `serve` command
- **Verification**: Health check on `http://localhost:8090/api/health`
- **Expected**: PocketBase serves on default port 8090

### 2. Environment Variable Configuration

- **Test**: Custom `PB_HOST` and `PB_PORT` environment variables
- **Configuration**: `PB_HOST=0.0.0.0`, `PB_PORT=8091`
- **Verification**: Health check on `http://localhost:8091/api/health`
- **Expected**: PocketBase serves on configured host/port

**Supported Environment Variables:**

- `PB_HOST`: Network interface to bind to (default: `0.0.0.0`)
- `PB_PORT`: Port to listen on (default: `8090`)
- `PB_ADMIN_EMAIL`: Admin email for automatic superuser creation
- `PB_ADMIN_PASSWORD`: Admin password for automatic superuser creation### 3. Development Mode

- **Test**: Container starts with `--dev` flag
- **Verification**: Health check confirms development mode active
- **Expected**: PocketBase runs in development mode with additional debugging

### 4. Global Commands

- **Test**: `--version` and `--help` commands work correctly
- **Verification**: Output contains expected PocketBase information
- **Expected**: Commands execute and exit properly

### 5. Direct Command Execution

- **Test**: Admin commands like `admin --help` work
- **Verification**: Output contains admin command help
- **Expected**: Commands pass through to PocketBase binary

### 6. Automatic Superuser Creation

- **Test**: Container automatically creates superuser when environment variables are set
- **Configuration**: `PB_ADMIN_EMAIL=test@example.com`, `PB_ADMIN_PASSWORD=testpassword123`
- **Verification**: Health check and log verification for "Successfully saved superuser" message
- **Expected**: Superuser is created/updated on container startup

### 7. Shell Access

- **Test**: Can execute shell commands in container
- **Verification**: Simple shell command execution
- **Expected**: Container provides shell access for debugging

## Running Tests

### Prerequisites

- Docker and Docker Compose installed
- `curl` and `wget` available (for health checks)
- Ports 8090, 8091, 8092, and 8093 available on host

### Local Testing

#### Run All Tests

```bash
# Using the test script (from project root)
./tests/test.sh

# Using Make (from project root)
make test
```

#### Run Specific Tests

```bash
# Test default behavior only
make test-default

# Test environment variables only
make test-env

# Manual service testing (from project root)
docker compose -f tests/compose.test.yaml up test-default
```

#### Clean Up

```bash
# Clean up all test resources (from project root)
make clean

# Manual cleanup (from project root)
docker compose -f tests/compose.test.yaml down -v --remove-orphans
```

### CI/CD Testing

The GitHub Actions workflow (`.github/workflows/test.yml`) automatically runs all tests on:

- Push to `main` or `develop` branches
- Pull requests to `main` branch
- Manual workflow dispatch

### Test Structure

```
pocketbase-docker/
├── tests/
│   ├── compose.test.yaml   # Test service definitions
│   ├── test.sh             # Main test runner script
│   └── TESTING.md          # This documentation
├── Makefile               # Convenient test commands
├── Dockerfile             # Docker image definition
└── entrypoint.sh          # Container entrypoint script
```

### Health Check Details

Each test service includes a health check that:

- Attempts to reach `/api/health` endpoint
- Retries up to 3 times with 10-second intervals
- Waits 10 seconds before starting checks
- Times out after 5 seconds per attempt

### Test Output

The test script provides colored output:

- 🟢 **Green**: Passed tests
- 🔴 **Red**: Failed tests
- 🟡 **Yellow**: Informational messages

### Troubleshooting

#### Port Conflicts

If tests fail due to port conflicts, ensure ports 8090, 8091, 8092, and 8093 are available:

```bash
# Check port usage
lsof -i :8090 -i :8091 -i :8092 -i :8093

# Stop conflicting services (from project root)
docker compose -f tests/compose.test.yaml down
```

#### Container Health Issues

Check container logs for debugging:

```bash
# View logs for specific service (from project root)
docker compose -f tests/compose.test.yaml logs test-default

# View all service logs (from project root)
docker compose -f tests/compose.test.yaml logs
```

#### Build Issues

Clean Docker cache and rebuild:

```bash
make clean
docker system prune -f
make build
```

## Test Maintenance

### Adding New Tests

1. Add new service to `tests/compose.test.yaml`
2. Add corresponding test logic to `tests/test.sh`
3. Update this documentation
4. Test locally before committing

### Updating Tests

When modifying the Docker image or entrypoint:

1. Review affected test cases
2. Update test expectations if needed
3. Ensure all tests pass locally
4. Update documentation as needed
