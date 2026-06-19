ARG GOLANG_VERSION=1.26.4
ARG VARIANT=alpine

FROM golang:${GOLANG_VERSION}-${VARIANT} AS builder

ARG GOLANGCI_LINT_VERSION=v2.12.2
ARG GOIMPORTS_VERSION=v0.46.0
ARG SQLC_VERSION=v1.31.1
ARG GOVULNCHECK_VERSION=v1.1.4

RUN if [ -f /etc/alpine-release ]; then \
        apk add --no-cache gcc musl-dev; \
    fi && \
    go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION} && \
    go install golang.org/x/tools/cmd/goimports@${GOIMPORTS_VERSION} && \
    go install github.com/sqlc-dev/sqlc/cmd/sqlc@${SQLC_VERSION} && \
    go install golang.org/x/vuln/cmd/govulncheck@${GOVULNCHECK_VERSION}

FROM golang:${GOLANG_VERSION}-${VARIANT}

RUN if [ -f /etc/alpine-release ]; then \
        apk add --no-cache make bash; \
    else \
        apt-get update && apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*; \
    fi

COPY --from=builder /go/bin/golangci-lint /usr/local/bin/
COPY --from=builder /go/bin/goimports /usr/local/bin/
COPY --from=builder /go/bin/sqlc /usr/local/bin/
COPY --from=builder /go/bin/govulncheck /usr/local/bin/

WORKDIR /app

CMD ["bash"]