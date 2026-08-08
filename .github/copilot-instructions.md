# GraalVM Docker Image - Copilot Instructions

## Project Overview

This is a minimal Docker image builder for GraalVM CE, used by SoftInstigate to run RESTHeart. The image is based on Debian Stable Slim and uses SDKMAN to install and manage GraalVM versions.

## Architecture & Key Components

- **Dockerfile**: Multi-stage build (downloader + final), downloads GraalVM directly from GitHub releases
- **Dockerfile.distroless**: Alternative distroless variant for minimal image size (~365MB)
- **bin/build.sh & bin/push.sh**: Local development scripts for manual image operations
- **CI/CD**: GitHub Actions (`.github/workflows/docker-image.yml`) handles automated builds on git tags
- **Version Management**: GRAALVM_VERSION defined once in GitHub Actions env, used across both Dockerfile builds

## Critical Workflows

### Building Locally
```bash
./bin/build.sh  # Builds image with --no-cache flag
```

### Publishing (Automated)
- Push a git tag (e.g., `git tag 1.0.0 && git push --tags`)
- GitHub Actions automatically builds and pushes multi-arch images (amd64, arm64)
- Tags both `latest` and the specific version (e.g., `1.0.0`)

### Version Updates
When updating GraalVM version:
1. Update `GRAALVM_VERSION` in `.github/workflows/docker-image.yml` (format: `25.1.3`)
2. Workflow auto-extracts major/minor/full versions for tag generation
3. Update version in `README.md` under "Versions" section
4. Test build locally: `./bin/build.sh` (uses Dockerfile directly)
5. Push git tag to trigger CI (e.g., `git tag 25.1.3-graalce && git push --tags`)

## Project-Specific Conventions

### Direct Download Architecture
- GraalVM is downloaded directly from `https://github.com/graalvm/graalvm-ce-builds/releases`
- Multi-stage build: "downloader" stage handles architecture detection and GraalVM extraction
- Architecture mapping: `amd64` → `linux-x64`, `arm64` → `linux-aarch64`
- Space optimization: Removes GUI libs, visualvm, documentation, and unnecessary .so files

### Image Variants
- **Shell variant** (Dockerfile): Includes `sh`, useful for debugging (default `CMD ["sh"]`)
- **Distroless variant** (Dockerfile.distroless): Minimal footprint, production-focused
- Both variants: ~365MB with GraalVM JDK and minimal locale support

### Multi-Architecture Support
- Images built for both `linux/amd64` and `linux/arm64`
- Uses Docker Buildx with QEMU emulation in GitHub Actions
- `TARGETARCH` build arg enables dynamic architecture detection
- Local builds: `./bin/build.sh` builds for current host architecture only

### Environment & Runtime
- `JAVA_HOME=/opt/graalvm`, `PATH` includes `$JAVA_HOME/bin`
- Locale: `en_US.UTF-8` (generated in final stage)
- `JAVA_OPTS="-Djava.awt.headless=true"` for server-only usage
- `WORKDIR=/opt/app` for application mounting

## Usage Pattern
The image is designed as a runtime for Java applications:
```bash
docker run -it --rm -v "$PWD":/opt/app softinstigate/graalvm java -jar /opt/app/myapp.jar
```

## CI Behavior
- Runs on `ubuntu-24.04` (latest LTS)
- Triggers only on **tag pushes** (not regular commits)
- Can be skipped with `[skip ci]` in commit message
- Requires `DOCKER_USER` and `DOCKER_TOKEN` secrets in repository settings
- Automatically extracts version components from `GRAALVM_VERSION` for tag generation
