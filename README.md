# golang-with-tools

Opinionated Docker image based on `golang` and `alpine` with common Go development tools pre-installed.

## Included Tools

| Tool | Description |
|------|-------------|
| make | Build tool (git, curl, wget, bash included in trixie) |
| golangci-lint | Go linter aggregator |
| goimports | Import formatter |
| sqlc | SQL code generator |
| govulncheck | Vulnerability scanner |

## Usage

### Pull from Docker Hub

```bash
docker pull <username>/golang-with-tools:latest
```

### Build locally with custom Go version

```bash
docker build --build-arg GOLANG_VERSION=1.26.4 -t golang-with-tools .
```

### Run

```bash
docker run -it --rm -v $(pwd):/app golang-with-tools bash
```

## CI/CD

The GitHub Actions workflow (`.github/workflows/docker.yml`) automatically:

- **On push to `main`** - builds and pushes `latest` tag
- **On version tags (`v*`)** - builds and pushes semver tags (e.g. `v1.0.0`, `1.0`, `1`)
- **On pull request** - builds only (no push)
- **On workflow dispatch** - allows overriding the Go version
