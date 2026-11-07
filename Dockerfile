FROM alpine:3.24.3 AS downloader

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG VERSION

ENV BUILDX_ARCH="${TARGETOS:-linux}_${TARGETARCH:-amd64}${TARGETVARIANT}"

RUN wget -q -O /tmp/pocketbase.zip "https://ganigeorgiev.com/meta/pocketbase/pocketbase/download/v${VERSION}/pocketbase_${VERSION}_${BUILDX_ARCH}.zip" \
    && unzip /tmp/pocketbase.zip -d / \
    && chmod +x /pocketbase \
    && rm /tmp/pocketbase.zip

FROM alpine:3.24.3
RUN apk update && apk add ca-certificates tzdata && rm -rf /var/cache/apk/*

COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
