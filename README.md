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

## Run the following command to build the image:

```
docker build -t pocketbase --build-args VERSION=x.x.x .
```

## Run

### Docker cli

```sh
docker run -ti --rm -p 8090:8090 -v $PWD/pocketbase:/data ghcr.io/muchobien/pocketbase pocketbase serve --http="0.0.0.0:8090" --dir /data
```

### docker-compose

```yml
version: "3.7"
services:
  pocketbase:
    image: ghcr.io/muchobien/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    command:
      - pocketbase
      - serve
      - --http
      - 0.0.0.0:8090
      - --dir
      - /data
      - --encryptionEnv
      - ENCRYPTION
    environment:
      ENCRYPTION: "${ENCRYPTION}"
    ports:
      - "8090:8090"
    volumes:
      - ./pocketbase:/data
```

## Related Repositories

- [PocketBase](https://github.com/pocketbase/pocketbase)
