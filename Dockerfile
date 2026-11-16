# renovate: datasource=golang-version depName=golang
ARG GOLANG_VERSION=1.27.4
ARG VARIANT=alpine

FROM golang:${GOLANG_VERSION}-${VARIANT} AS builder

# renovate: datasource=go depName=github.com/golangci/golangci-lint/v2
ARG GOLANGCI_LINT_VERSION=v2.15.0
# renovate: datasource=go depName=golang.org/x/tools
ARG GOIMPORTS_VERSION=v0.52.0
# renovate: datasource=go depName=github.com/sqlc-dev/sqlc
ARG SQLC_VERSION=v1.31.1
# renovate: datasource=go depName=golang.org/x/vuln
ARG GOVULNCHECK_VERSION=v1.9.0

# Security overrides until sqlc releases with patched dependencies.
# renovate: datasource=go depName=golang.org/x/net
ARG SQLC_NET_VERSION=v0.62.0
# renovate: datasource=go depName=google.golang.org/grpc
ARG SQLC_GRPC_VERSION=v1.83.2
# renovate: datasource=go depName=github.com/google/cel-go
ARG SQLC_CEL_VERSION=v0.30.0

RUN if [ -f /etc/alpine-release ]; then \
        apk upgrade --no-cache && \
        apk add --no-cache gcc musl-dev; \
    fi && \
    go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION} && \
    go install golang.org/x/tools/cmd/goimports@${GOIMPORTS_VERSION} && \
    (mkdir -p /tmp/sqlc-build && cd /tmp/sqlc-build && \
        go mod init sqlc-build && \
        go get github.com/sqlc-dev/sqlc/cmd/sqlc@${SQLC_VERSION} \
            golang.org/x/net@${SQLC_NET_VERSION} \
            google.golang.org/grpc@${SQLC_GRPC_VERSION} \
            github.com/google/cel-go@${SQLC_CEL_VERSION} && \
        go install github.com/sqlc-dev/sqlc/cmd/sqlc) && \
    go install golang.org/x/vuln/cmd/govulncheck@${GOVULNCHECK_VERSION}

FROM golang:${GOLANG_VERSION}-${VARIANT}

RUN if [ -f /etc/alpine-release ]; then \
        apk upgrade --no-cache && \
        apk add --no-cache make bash; \
    else \
        apt-get update && apt-get upgrade -y && \
        apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*; \
    fi

COPY --from=builder /go/bin/golangci-lint /usr/local/bin/
COPY --from=builder /go/bin/goimports /usr/local/bin/
COPY --from=builder /go/bin/sqlc /usr/local/bin/
COPY --from=builder /go/bin/govulncheck /usr/local/bin/

WORKDIR /app

CMD ["bash"]
