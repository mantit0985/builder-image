# Distroless cannot host these toolchains (no shell, no package manager):
# the distroless target aliases the slim runtime, matching the runner-repo
# pattern (github-actions-runner origin/main Dockerfile).
FROM debian:bookworm-slim AS runtime-slim

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl git jq unzip xz-utils nodejs npm; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

FROM alpine:3.20 AS runtime-alpine

RUN set -eux; \
    apk add --no-cache ca-certificates curl git jq unzip xz nodejs npm

FROM runtime-slim AS runtime-distroless
