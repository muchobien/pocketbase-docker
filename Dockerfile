FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS downloader

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG VERSION

ENV BUILDX_ARCH="${TARGETOS:-linux}_${TARGETARCH:-amd64}${TARGETVARIANT}"

RUN wget https://ganigeorgiev.com/meta/pocketbase/pocketbase/download/v${VERSION}/pocketbase_${VERSION}_${BUILDX_ARCH}.zip \
    && wget https://ganigeorgiev.com/meta/pocketbase/pocketbase/download/v${VERSION}/checksums.txt \
    && awk -v archive="pocketbase_${VERSION}_${BUILDX_ARCH}.zip" '$2 == archive' checksums.txt \
        | sha256sum -c - \
    && unzip pocketbase_${VERSION}_${BUILDX_ARCH}.zip \
    && chmod +x /pocketbase

FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a
RUN apk update && apk add ca-certificates tzdata && rm -rf /var/cache/apk/*

COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
