# graalvm-docker

[![Docker Hub](https://img.shields.io/docker/v/softinstigate/graalvm?label=Docker%20Hub)](https://hub.docker.com/r/softinstigate/graalvm)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

GraalVM Docker images for running [RESTHeart](https://restheart.org) and other headless Java services. Maintained by [SoftInstigate](https://softinstigate.com).

## Why This Exists

RESTHeart runs on GraalVM in production. Official GraalVM images weigh ~878 MB and ship with GUI libraries, native-image tools, and debug symbols that a headless server never uses.

This repository strips those components during the Docker build, producing images at ~285 MB (68% smaller). The distroless variant, based on [Google's distroless](https://github.com/GoogleContainerTools/distroless), removes the shell and package manager entirely, reducing the CVE surface by ~90%. Both images are built for `amd64` and `arm64` and published to Docker Hub as `softinstigate/graalvm`.

## Quick Start

```bash
# Run a JAR (distroless, no shell)
docker run --rm -v "$PWD":/opt/app \
  softinstigate/graalvm:25 \
  -jar /opt/app/restheart.jar

# Interactive debugging (shell variant)
docker run -it softinstigate/graalvm:25-shell /bin/sh
```

## Image Variants

### Distroless (default) — 285 MB

No shell. No package manager. Runs as non-root (UID 65532). Based on Google's distroless base image. Cannot `docker exec` into the container. Use remote JDWP debugging or the shell variant for interactive access.

```bash
docker run --rm -v "$PWD":/opt/app \
  softinstigate/graalvm:25 \
  -jar /opt/app/app.jar
```

### Shell variant — 365 MB

Includes `/bin/sh` for interactive debugging and `docker exec`. Based on `debian:stable-slim`.

```bash
docker run -it softinstigate/graalvm:25-shell /bin/sh
```

## Tags

All tags support **amd64** and **arm64** automatically.

| Variant | Tags |
|---|---|
| Distroless | `latest`, `25`, `25.1`, `25.1.3` |
| Shell | `25-shell`, `25.1-shell`, `25.1.3-shell` |

## What's Included

- GraalVM JDK 25 (HotSpot + GraalVM JIT)
- All Java standard libraries
- Headless mode (`JAVA_OPTS="-Djava.awt.headless=true"`)
- HTTPS/TLS support (CA certificates)

## What's Removed (Size Optimization)

Server-side Java does not need GUI toolkits, native-image build tools, or static libraries. The build strips ~593 MB of components:

| Removed | Savings |
|---|---|
| GUI libraries (AWT, Swing, JavaFX) | ~20 MB |
| Native-image build tools | ~37 MB |
| Static libraries | ~183 MB |
| SubstrateVM components | ~64 MB |
| jmods | ~110 MB |
| Samples/demos | ~60 MB |

See [Docker Build Architecture](openwiki/architecture/docker-build.md) for the full rationale.

## Using as a Base Image

```dockerfile
FROM softinstigate/graalvm:25
COPY app.jar /opt/app/
CMD ["-jar", "/opt/app/app.jar"]
```

Docker Compose:

```yaml
services:
  app:
    image: softinstigate/graalvm:25
    command: ["-jar", "/opt/app/app.jar"]
    volumes:
      - ./:/opt/app
```

## Prerequisites

- Docker Desktop or Docker Engine with [Buildx](https://docs.docker.com/build/buildx/) enabled
- (Multi-arch builds) QEMU emulation. CI sets this up automatically. For local builds: `docker run --privileged --rm tonistiigi/binfmt --install all`

## Building

```bash
# Local, current architecture only
docker build -f Dockerfile.distroless -t myimage:25 .       # distroless
docker build -t myimage:25-shell .                           # shell

# Multi-arch, builds and pushes both variants
./build-multiarch.sh

# CI/CD, automatic on git tag push
git tag 25.1.3-graalce && git push origin 25.1.3-graalce
```

The `GRAALVM_VERSION` is defined once in [`.github/workflows/docker-image.yml`](.github/workflows/docker-image.yml) and passed as a build arg to both Dockerfiles.

## Debugging Distroless

Distroless has no shell. Use remote JDWP:

```bash
docker run -p 5005:5005 softinstigate/graalvm:25 \
  -agentlib:jdwp=transport=dt_socket,server=y,address=*:5005 \
  -jar /opt/app/app.jar
```

Or switch to the shell variant for interactive access.

## Security Model

| Property | Distroless | Shell |
|---|---|---|
| Shell available | No | Yes |
| Package manager | No | Yes |
| Runs as | Non-root (65532) | Root (configurable) |
| `docker exec` possible | No | Yes |
| CVE surface | Minimal | Standard Debian |

## Multi-Architecture

Works on Intel/AMD (x86_64), Apple Silicon (M1/M2/M3/M4), AWS Graviton, and ARM servers. Docker pulls the correct architecture for the host automatically.

## Updating GraalVM Version

1. Set `GRAALVM_VERSION`, `GRAALVM_RELEASE_TAG`, and `GRAALVM_ARCHIVE_VERSION` in [`.github/workflows/docker-image.yml`](.github/workflows/docker-image.yml)
2. Update the same values in `Dockerfile` and `Dockerfile.distroless`
3. Update the version in this `README.md`
4. Test locally: `docker build -f Dockerfile.distroless .`
5. Tag and push: `git tag 25.1.3-graalce && git push origin 25.1.3-graalce`

## License

[Apache 2.0](LICENSE)
