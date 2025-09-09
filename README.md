<p align="center">
  <a href="https://pocketbase.io/">
    <img alt="PocketBase logo" height="128" src="https://pocketbase.io/images/logo.svg">
    <h1 align="center">Docker Image for PocketBase</h1>
  </a>
</p>

<p align="center">
   <a aria-label="Latest PocketBase Version" href="https://github.com/pocketbase/pocketbase/releases" target="_blank">
    <img alt="Latest PocketBase Version" src="https://img.shields.io/github/v/release/pocketbase/pocketbase?color=success&display_name=tag&label=latest&logo=docker&logoColor=%23fff&sort=semver&style=flat-square">
  </a>
  <a aria-label="Supported architectures" href="https://github.com/pocketbase/pocketbase/releases" target="_blank">
    <img alt="Supported Docker architectures" src="https://img.shields.io/badge/platform-amd64%20%7C%20arm64%20%7C%20armv7-brightgreen?style=flat-square&logo=linux&logoColor=%23fff">
  </a>
</p>

---

## Quick Start

```bash
# Basic usage - starts PocketBase server on port 8090
docker run --rm -p 8090:8090 ghcr.io/muchobien/pocketbase:latest

# Access the Admin UI at http://localhost:8090/_/
```

> [!TIP]
> For production use, mount volumes for data persistence: `-v ./pb_data:/pb_data`

## Features

- 🚀 **Smart Entrypoint**: Automatically serves PocketBase with sensible defaults
- 🔧 **Flexible Commands**: Run any PocketBase command (migrate, superuser, etc.)
- 🌐 **Configurable Host/Port**: Use `PB_HOST` and `PB_PORT` environment variables
- � **Auto Superuser**: Automatically create/update superuser with `PB_ADMIN_EMAIL` and `PB_ADMIN_PASSWORD`
- �📦 **Multi-Architecture**: Supports amd64, arm64, and armv7
- 🛡️ **Secure Defaults**: Follows Docker and PocketBase best practices

## Environment Variables

| Variable            | Default   | Description                                     |
| ------------------- | --------- | ----------------------------------------------- |
| `PB_HOST`           | `0.0.0.0` | Network interface to bind to                    |
| `PB_PORT`           | `8090`    | Port to listen on                               |
| `PB_ADMIN_EMAIL`    | -         | Admin email for automatic superuser creation    |
| `PB_ADMIN_PASSWORD` | -         | Admin password for automatic superuser creation |

> [!NOTE]  
> When changing `PB_PORT`, remember to also update the Docker port mapping (e.g., `-p 3000:3000` for port 3000).

## Usage Examples

### Default Server

```bash
# Starts PocketBase server with default settings
docker run --rm -p 8090:8090 ghcr.io/muchobien/pocketbase:latest
```

### Custom Host and Port

```bash
# Custom port
docker run --rm -p 3000:3000 -e PB_PORT=3000 ghcr.io/muchobien/pocketbase:latest

# Localhost only (security)
docker run --rm -p 8090:8090 -e PB_HOST=127.0.0.1 ghcr.io/muchobien/pocketbase:latest

# Custom host and port
docker run --rm -p 9000:9000 -e PB_HOST=0.0.0.0 -e PB_PORT=9000 ghcr.io/muchobien/pocketbase:latest
```

### Automatic Superuser Creation

```bash
# Create superuser automatically on startup
docker run --rm -p 8090:8090 \
  -e PB_ADMIN_EMAIL=admin@example.com \
  -e PB_ADMIN_PASSWORD=supersecret123 \
  ghcr.io/muchobien/pocketbase:latest

# With data persistence
docker run -d --name pocketbase \
  -p 8090:8090 \
  -v $(pwd)/pb_data:/pb_data \
  -e PB_ADMIN_EMAIL=admin@example.com \
  -e PB_ADMIN_PASSWORD=supersecret123 \
  ghcr.io/muchobien/pocketbase:latest
```

> [!NOTE]
> The superuser is created/updated only when using default serve behavior (no custom commands).
> Uses `pocketbase superuser upsert` internally, so it's safe to restart containers.

> [!WARNING]
> Store admin credentials securely! Consider using Docker secrets or encrypted environment files in production.

### Development Mode

```bash
# Enable development mode with detailed logging
docker run --rm -p 8090:8090 ghcr.io/muchobien/pocketbase:latest --dev

# Development with custom port
docker run --rm -p 3000:3000 -e PB_PORT=3000 ghcr.io/muchobien/pocketbase:latest --dev
```

> [!WARNING]  
> Never use `--dev` flag in production as it exposes sensitive information in logs.

### PocketBase Commands

```bash
# Show help
docker run --rm ghcr.io/muchobien/pocketbase:latest --help

# Show version
docker run --rm ghcr.io/muchobien/pocketbase:latest --version

# Run database migrations
docker run --rm -v ./pb_data:/pb_data ghcr.io/muchobien/pocketbase:latest migrate

# Create superuser
docker run --rm -it -v ./pb_data:/pb_data ghcr.io/muchobien/pocketbase:latest superuser create

# Superuser help
docker run --rm ghcr.io/muchobien/pocketbase:latest superuser --help
```

### Shell Access

```bash
# Access shell for debugging or maintenance
docker run --rm -it --entrypoint /bin/sh ghcr.io/muchobien/pocketbase:latest
```

## Production Deployment

Below are example configurations for production deployment.

### Using Docker Compose (Recommended)

```yaml
services:
  pocketbase:
    image: ghcr.io/muchobien/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    environment:
      # Optional: Configure host and port (defaults: 0.0.0.0:8090)
      PB_HOST: 0.0.0.0
      PB_PORT: 8090
      # Optional: Auto-create superuser (recommended for production)
      PB_ADMIN_EMAIL: admin@yourdomain.com
      PB_ADMIN_PASSWORD: your-secure-password-here
      # Optional: Enable settings encryption (32-character key)
      # https://pocketbase.io/docs/going-to-production/#enable-settings-encryption
      ENCRYPTION: $(openssl rand -hex 16)
      # Optional: Set timezone
      TZ: Europe/Berlin
    ports:
      - "8090:8090" # Change both port and PB_PORT for custom ports: "3000:3000"
    volumes:
      - ./pb_data:/pb_data
      - ./pb_public:/pb_public # optional
      - ./pb_hooks:/pb_hooks # optional
    # Optional: Add encryption flag if using ENCRYPTION env var
    command: ["--encryptionEnv", "ENCRYPTION"]
    healthcheck:
      test:
        [
          "CMD",
          "wget",
          "--no-verbose",
          "--tries=1",
          "--spider",
          "http://localhost:8090/api/health",
        ]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
```

> [!WARNING]  
> Always use volumes for data persistence in production. Without volumes, all data will be lost when the container stops.

### Using Docker CLI

```bash
# Basic production setup (default: 0.0.0.0:8090)
docker run -d \
  --name=pocketbase \
  -p 8090:8090 \
  -v $(pwd)/pb_data:/pb_data \
  -v $(pwd)/pb_public:/pb_public \
  -v $(pwd)/pb_hooks:/pb_hooks \
  --restart unless-stopped \
  ghcr.io/muchobien/pocketbase:latest

# With custom port, host, superuser, and encryption
docker run -d \
  --name=pocketbase \
  -p 3000:3000 \
  -e PB_HOST=0.0.0.0 \
  -e PB_PORT=3000 \
  -e PB_ADMIN_EMAIL=admin@yourdomain.com \
  -e PB_ADMIN_PASSWORD=your-secure-password-here \
  -e ENCRYPTION=$(openssl rand -hex 16) \
  -v $(pwd)/pb_data:/pb_data \
  -v $(pwd)/pb_public:/pb_public \
  -v $(pwd)/pb_hooks:/pb_hooks \
  --restart unless-stopped \
  ghcr.io/muchobien/pocketbase:latest \
  --encryptionEnv ENCRYPTION
```

> [!IMPORTANT]  
> For production deployments, use strong encryption keys and secure your environment variables.

# Development setup with logging

```bash
docker run -d \
 --name=pocketbase-dev \
 -p 8090:8090 \
 -v $(pwd)/pb_data:/pb_data \
 ghcr.io/muchobien/pocketbase:latest \
 --dev
```

## Advanced Usage

### Building the Image Locally

```bash
# Build with specific PocketBase version
docker build --build-arg VERSION=0.22.21 -t my-pocketbase .

# Build with latest version (uses latest release from GitHub)
docker build --build-arg VERSION=0.23.0 -t my-pocketbase:0.23.0 .

# Build without specifying version (uses default from Dockerfile)
docker build -t my-pocketbase:dev .
```

### Docker Compose for Development

```yaml
services:
  pocketbase:
    build:
      context: .
      args:
        - VERSION=0.22.21
    container_name: pocketbase-dev
    environment:
      PB_HOST: 0.0.0.0
      PB_PORT: 8090
    ports:
      - "8090:8090"
    volumes:
      - ./pb_data:/pb_data
      - ./pb_public:/pb_public
      - ./pb_hooks:/pb_hooks
    command: ["--dev"]
```

### Database Administration

> [!IMPORTANT]  
> These examples assume you have a running PocketBase container.

#### Using Docker CLI with Running Container

```bash
# First, start your PocketBase container (if not already running)
docker run -d --name pocketbase -p 8090:8090 -v $(pwd)/pb_data:/pb_data ghcr.io/muchobien/pocketbase:latest

# Create superuser in running container
docker exec -it pocketbase /usr/local/bin/pocketbase superuser create --dir /pb_data

# Run migrations in running container
docker exec pocketbase /usr/local/bin/pocketbase migrate --dir /pb_data

# Check PocketBase version
docker exec pocketbase /usr/local/bin/pocketbase --version --dir /pb_data

# View superuser help
docker exec pocketbase /usr/local/bin/pocketbase superuser --help --dir /pb_data
```

#### Using Docker Compose

```yaml
# compose.yml - your running setup
services:
  pocketbase:
    image: ghcr.io/muchobien/pocketbase:latest
    container_name: pocketbase
    ports:
      - "8090:8090"
    volumes:
      - ./pb_data:/pb_data
```

```bash
# Start your services
docker compose up -d

# Administration commands via compose
docker compose exec pocketbase pocketbase superuser create --dir /pb_data
docker compose exec pocketbase pocketbase migrate --dir /pb_data
docker compose exec pocketbase pocketbase --version --dir /pb_data
docker compose exec pocketbase pocketbase superuser --help --dir /pb_data

# View logs
docker compose logs pocketbase

# Stop services
docker compose down
```

#### One-time Administration (without running container)

> [!TIP]
> Use this approach when you need to run admin commands before starting the server permanently.

```bash
# Create superuser before starting server
docker run --rm -it -v $(pwd)/pb_data:/pb_data \
  ghcr.io/muchobien/pocketbase:latest superuser create

# Run migrations before starting server
docker run --rm -v $(pwd)/pb_data:/pb_data \
  ghcr.io/muchobien/pocketbase:latest migrate

# Then start your server normally
docker run -d --name pocketbase -p 8090:8090 -v $(pwd)/pb_data:/pb_data \
  ghcr.io/muchobien/pocketbase:latest
```

## Troubleshooting

### Common Issues

**Port already in use:**

```bash
# Use a different port
docker run --rm -p 3000:3000 -e PB_PORT=3000 ghcr.io/muchobien/pocketbase:latest
```

**Permission issues with volumes:**

> [!CAUTION]
> On Linux systems, ensure proper file ownership for mounted volumes.

```bash
# Ensure proper ownership (Linux/macOS)
sudo chown -R 1000:1000 ./pb_data ./pb_public ./pb_hooks
```

**Cannot connect from outside container:**

```bash
# Ensure PB_HOST is set to 0.0.0.0 (default)
docker run --rm -p 8090:8090 -e PB_HOST=0.0.0.0 ghcr.io/muchobien/pocketbase:latest
```

**Updating PocketBase:**

```bash
# Pull the latest image
docker pull ghcr.io/muchobien/pocketbase:latest

# Stop and remove old container
docker stop pocketbase && docker rm pocketbase

# Start with new image (preserve data with volume mounts)
docker run -d --name pocketbase -p 8090:8090 -v $(pwd)/pb_data:/pb_data ghcr.io/muchobien/pocketbase:latest

# Or with Docker Compose
docker compose pull
docker compose up -d
```

### Debugging

```bash
# Check container logs
docker logs pocketbase

# Access container shell
docker exec -it pocketbase /bin/sh

# Run with debug logging
docker run --rm -p 8090:8090 ghcr.io/muchobien/pocketbase:latest --dev
```

## Image Information

### Supported Architectures

This image supports multiple architectures. Docker will automatically pull the correct image for your platform:

| Architecture   | Status |
| -------------- | ------ |
| `linux/amd64`  | ✅     |
| `linux/arm64`  | ✅     |
| `linux/arm/v7` | ✅     |

### Available Tags

| Tag      | Description                        |
| -------- | ---------------------------------- |
| `latest` | Latest PocketBase release          |
| `0.22.x` | Specific version (e.g., `0.22.21`) |
| `0.22`   | Latest patch in minor version      |
| `0`      | Latest release in major version    |

## Related Repositories

- [PocketBase](https://github.com/pocketbase/pocketbase) - The official PocketBase repository
- [PocketBase Documentation](https://pocketbase.io/docs/) - Official documentation
