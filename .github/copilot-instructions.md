# GraalVM Docker Image - Copilot Instructions

## Project Overview

This is a minimal Docker image builder for GraalVM CE, used by SoftInstigate to run RESTHeart. The image is based on Debian Stable Slim and uses SDKMAN to install and manage GraalVM versions.

## Architecture & Key Components

- **Dockerfile**: Single-stage build using Debian as base, installs GraalVM via SDKMAN
- **bin/entrypoint.sh**: Sources bashrc to initialize SDKMAN environment before executing commands
- **bin/build.sh & bin/push.sh**: Local development scripts for manual image operations
- **CI/CD**: GitHub Actions (`.github/workflows/docker-image.yml`) handles automated builds on git tags

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
1. Modify `ARG JAVA_VERSION` in `Dockerfile` (format: `25-graalce`)
2. Update version in `README.md` under "Versions" section
3. Test build locally before tagging

## Project-Specific Conventions

### SDKMAN Integration
- SDKMAN is installed at `/root/.sdkman`
- Configuration flags: `auto_answer=true`, `auto_selfupdate=false`, `insecure_ssl=true`
- Entrypoint sources bashrc to make `sdk` and `java` commands available
- Archives and tmp files are cleaned post-install to reduce image size

### Multi-Architecture Support
- Images are built for both `linux/amd64` and `linux/arm64`
- Uses Docker Buildx with QEMU emulation in CI
- Local builds default to host architecture only

### Shell Environment
- `SHELL ["/bin/bash", "-i", "-c"]` in Dockerfile enables interactive bash for SDK commands
- Entrypoint pattern: `source /root/.bashrc && "$@"` ensures environment is loaded before running user commands

## Usage Pattern
The image is designed as a runtime for Java applications:
```bash
docker run -it --rm -v "$PWD":/opt/app softinstigate/graalvm java -jar /opt/app/myapp.jar
```

## CI Behavior
- Triggers only on **tag pushes** (not regular commits)
- Can be skipped with `[skip ci]` in commit message
- Requires `DOCKER_USER` and `DOCKER_TOKEN` secrets in repository settings
