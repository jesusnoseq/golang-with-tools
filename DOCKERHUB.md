# golang-with-tools

A ready-to-use Go development image that bundles the official `golang` toolchain
with the linting, formatting, code-generation, and security tools you need for
everyday Go development and CI pipelines — no extra `go install` steps required.

🔗 **Source & docs:** https://github.com/jesusnoseq/golang-with-tools

## What's inside

| Tool          | Description                       |
|---------------|-----------------------------------|
| go            | The Go toolchain                  |
| make          | Build automation                  |
| bash          | Shell                             |
| golangci-lint | Go linter aggregator             |
| goimports     | Import formatter                  |
| sqlc          | Type-safe SQL code generator     |
| govulncheck   | Vulnerability scanner            |

## Variants & tags

Two flavors are published:

- **alpine** (default) — small image based on `golang:*-alpine`
- **trixie** — Debian-based (`golang:*`), glibc, maximally compatible

Common tags:

- `latest` — newest build from `main` (alpine)
- `latest-alpine`, `latest-trixie` — newest build of each variant
- `1.2.3-alpine`, `1.2-alpine`, `1-alpine` — semver tags per variant
- `go<ver>-<variant>-lint<ver>-imports<ver>-sqlc<ver>-vuln<ver>` — fully pinned tags

## Quick start

```bash
# Pull
docker pull jesusnoseq/golang-with-tools:latest

# Interactive shell with your project mounted
docker run -it --rm -v "$(pwd)":/app jesusnoseq/golang-with-tools bash

# Run a single tool
docker run --rm -v "$(pwd)":/app jesusnoseq/golang-with-tools golangci-lint run ./...
docker run --rm -v "$(pwd)":/app jesusnoseq/golang-with-tools govulncheck ./...
```

### In GitHub Actions

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

## Notes

- Working directory is `/app` — mount your code there.
- The default command is `bash`.
- Tool versions are pinned at build time; use a fully pinned tag for reproducible CI.

## License

MIT © Jesús Rodríguez Pérez
