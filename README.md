<p align="center">
  <a href="https://pocketbase.io/">
    <img alt="pocketbase logo" height="128" src="https://pocketbase.io/images/logo.svg">
    <h1 align="center">Docker image for PocketBase</h1>
  </a>
</p>

<p align="center">
   <a aria-label="Latest Pocketbase Version" href="https://github.com/pocketbase/pocketbase/releases" target="_blank">
    <img alt="Latest Pocketbase Version" src="https://img.shields.io/github/v/release/pocketbase/pocketbase?color=success&display_name=tag&label=latest&logo=docker&logoColor=%23fff&sort=semver&style=flat-square">
  </a>
  <a aria-label="Supported archs" href="https://github.com/pocketbase/pocketbase/releases" target="_blank">
    <img alt="Supported docker archs" src="https://img.shields.io/badge/platform-amd64%20%7C%20arm64%20%7C%20armv7-brightgreen?style=flat-square&logo=linux&logoColor=%23fff">
  </a>
</p>

---

## Supported Architectures

Simply pulling `ghcr.io/muchobien/pocketbase:latest` should retrieve the correct image for your arch.

The architectures supported by this image are:

| Architecture | Available |
| :----------: | :-------: |
|    amd64     |    ✅     |
|    arm64     |    ✅     |
|    armv7     |    ✅     |

## Version Tags

This image provides various versions that are available via tags. Please read the descriptions carefully and exercise caution when using unstable or development tags.

|  Tag   | Available | Description                     |
| :----: | :-------: | ------------------------------- |
| latest |    ✅     | Stable releases from PocketBase |
| x.x.x  |    ✅     | Patch release from PocketBase   |
|  x.x   |    ✅     | Minor release from PocketBase   |
|   x    |    ✅     | Major release from PocketBase   |

## Application Setup

Access the webui at `<your-ip>:8090`, for more information check out [PocketBase](https://pocketbase.io/docs/).

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose (recommended)

```yml
version: "3.7"
services:
  pocketbase:
    image: ghcr.io/muchobien/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    command:
      - --encryptionEnv #optional
      - ENCRYPTION #optional
    environment:
      ENCRYPTION: example #optional
    ports:
      - "8090:8090"
    volumes:
      - /path/to/data:/pb_data
      - /path/to/public:/pb_public #optional
      - /path/to/hooks:/pb_hooks #optional
    healthcheck: #optional (recommended) since v0.10.0
      test: wget --no-verbose --tries=1 --spider http://localhost:8090/api/health || exit 1
      interval: 5s
      timeout: 5s
      retries: 5
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=pocketbase \
  -p 8090:8090 \
  -e ENCRYPTION=example `#optional` \
  -v /path/to/data:/pb_data \
  -v /path/to/public:/pb_public `#optional` \
  -v /path/to/hooks:/pb_hooks `#optional` \
  --restart unless-stopped \
  ghcr.io/muchobien/pocketbase:latest \
  --encryptionEnv ENCRYPTION `#optional`
```

## Built the image yourself
Copy `Dockerfile` and `docker-compose.yml` to the root directory, then update the `docker-compose.yml` file to build the image instead of pulling:
```yml
version: "3.7"
services:
  pocketbase:
    build:
      context: .
      args:
        - VERSION=0.22.10 # <--------- Set the Pocketbase version here. It will be downloaded from their GitHub repo
    container_name: pocketbase
    restart: unless-stopped
    command:
      - --encryptionEnv #optional
      - ENCRYPTION #optional
    environment:
      ENCRYPTION: example #optional
    ports:
      - "8090:8090"
    volumes:
      - /path/to/data:/pb_data
      - /path/to/public:/pb_public #optional
      - /path/to/hooks:/pb_hooks #optional
    healthcheck: #optional (recommended) since v0.10.0
      test: wget --no-verbose --tries=1 --spider http://localhost:8090/api/health || exit 1
      interval: 5s
      timeout: 5s
      retries: 5
```

## Related Repositories

- [PocketBase](https://github.com/pocketbase/pocketbase)
