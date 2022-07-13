# Docker for [Pocketbase](https://pocketbase.io/)

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
version: '3.7'
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
