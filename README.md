# golang-with-tools

A ready-to-use Go development Docker image bundling the official `golang` image
with the linting, formatting, code-generation, and security tooling you reach
for in everyday Go work and CI pipelines.

[![Docker Hub](https://img.shields.io/docker/pulls/jesusnoseq/golang-with-tools?logo=docker)](https://hub.docker.com/r/jesusnoseq/golang-with-tools)
[![Image Size](https://img.shields.io/docker/image-size/jesusnoseq/golang-with-tools/latest?logo=docker)](https://hub.docker.com/r/jesusnoseq/golang-with-tools)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

📦 **Docker Hub:** [jesusnoseq/golang-with-tools](https://hub.docker.com/r/jesusnoseq/golang-with-tools)

## Included Tools

| Tool          | Description                                  |
|---------------|----------------------------------------------|
| go            | The Go toolchain (from the official image)   |
| make          | Build automation                             |
| bash          | Shell                                        |
| golangci-lint | Go linter aggregator                         |
| goimports     | Import formatter                             |
| sqlc          | Type-safe SQL code generator                 |
| govulncheck   | Vulnerability scanner                        |

## Tags

Images are built in two flavors. Pick the variant that matches your needs:

| Variant  | Base                  | Notes                                            |
|----------|-----------------------|--------------------------------------------------|
| `alpine` | `golang:*-alpine`     | Small image, musl libc. **This is the default.** |
| `trixie` | `golang:*` (Debian)   | glibc, larger but maximally compatible.          |

Common tag patterns:

- `latest` — newest build from `main` (alpine variant)
- `latest-alpine`, `latest-trixie` — newest build of each variant
- `1.2.3-alpine`, `1.2-alpine`, `1-alpine` — semver tags per variant (from `v*` git tags)
- `go<version>-<variant>-lint<version>-...` — fully pinned tag capturing every tool version

See all available tags on [Docker Hub](https://hub.docker.com/r/jesusnoseq/golang-with-tools/tags).

## Usage

### Pull from Docker Hub

```bash
docker pull jesusnoseq/golang-with-tools:latest
# or a specific variant
docker pull jesusnoseq/golang-with-tools:latest-trixie
```

### Run interactively

Mount your project into `/app` (the image's working directory) and drop into a shell:

```bash
docker run -it --rm -v "$(pwd)":/app jesusnoseq/golang-with-tools bash
```

### Run a single command

```bash
docker run --rm -v "$(pwd)":/app jesusnoseq/golang-with-tools golangci-lint run ./...
docker run --rm -v "$(pwd)":/app jesusnoseq/golang-with-tools govulncheck ./...
```

### Use in GitHub Actions

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    container: jesusnoseq/golang-with-tools:latest
    steps:
      - uses: actions/checkout@v4
      - run: golangci-lint run ./...
      - run: govulncheck ./...
```

## Building Locally

The Dockerfile is parameterized so you can pin every version via build args:

```bash
docker build \
  --build-arg GOLANG_VERSION=<version> \
  --build-arg VARIANT=alpine \
  --build-arg GOLANGCI_LINT_VERSION=<version> \
  --build-arg GOIMPORTS_VERSION=<version> \
  --build-arg SQLC_VERSION=<version> \
  --build-arg GOVULNCHECK_VERSION=<version> \
  -t golang-with-tools .
```

| Build arg               | Purpose                                |
|-------------------------|----------------------------------------|
| `GOLANG_VERSION`        | Go toolchain version                   |
| `VARIANT`               | Base image variant (`alpine`/`trixie`) |
| `GOLANGCI_LINT_VERSION` | golangci-lint version                  |
| `GOIMPORTS_VERSION`     | goimports version                      |
| `SQLC_VERSION`          | sqlc version                           |
| `GOVULNCHECK_VERSION`   | govulncheck version                    |

Default versions are defined in the [`Dockerfile`](Dockerfile) and kept up to
date automatically by Renovate.

A multi-stage build compiles the tools in a builder stage and copies only the
binaries into the final image to keep it lean.

## CI/CD

The GitHub Actions workflow ([`.github/workflows/docker.yml`](.github/workflows/docker.yml))
builds the full variant matrix and:

- **On push to `main`** — builds and pushes the `latest` / `latest-<variant>` tags
- **On version tags (`v*`)** — builds and pushes semver tags (e.g. `1.2.3`, `1.2`, `1`) per variant
- **On pull request** — builds only (no push)
- **On workflow dispatch** — lets you override Go, tool, and variant versions via JSON-array inputs

## Requesting a New Tool

Missing a tool you'd find useful in this image? [Open an issue](https://github.com/jesusnoseq/golang-with-tools/issues/new)
describing the tool and your use case, and it can be considered for inclusion.
Pull requests are welcome too.

## License

[MIT](LICENSE) © Jesús Rodríguez Pérez
