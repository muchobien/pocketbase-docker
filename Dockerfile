FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS downloader

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

FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf
RUN apk update && apk add ca-certificates tzdata && rm -rf /var/cache/apk/*

COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
