
# GraalVM Docker Image

[![Docker Pulls](https://img.shields.io/docker/pulls/softinstigate/graalvm)](https://hub.docker.com/r/softinstigate/graalvm)
[![Docker Image Size](https://img.shields.io/docker/image-size/softinstigate/graalvm/latest)](https://hub.docker.com/r/softinstigate/graalvm)
[![CI](https://github.com/SoftInstigate/graalvm-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/SoftInstigate/graalvm-docker/actions/workflows/docker-image.yml)

Minimal, multi-arch Docker image for [GraalVM CE](https://graalvm.org), maintained by [SoftInstigate](https://softinstigate.com) for running Java applications (e.g., [RESTHeart](https://restheart.org)). Built on Debian Stable Slim, with GraalVM managed via [SDKMAN](https://sdkman.io).

---

## Features

- **Multi-arch**: Supports `linux/amd64` and `linux/arm64`
- **Minimal base**: Debian Stable Slim
- **SDKMAN**: Flexible Java/GraalVM version management
- **Clean runtime**: Cleans up after install for small image size

---

## Usage

Run a Java application with GraalVM:

```sh
docker run -it --rm -v "$PWD":/opt/app softinstigate/graalvm java -jar /opt/app/myapp.jar
```

### Building Locally

```sh
./bin/build.sh  # Builds image with --no-cache
```

### Publishing (Automated)

1. Push a git tag (e.g., `git tag 1.0.0 && git push --tags`)
2. GitHub Actions builds and pushes multi-arch images (`amd64`, `arm64`)
3. Both `latest` and the version tag (e.g., `1.0.0`) are published

### Updating GraalVM Version

1. Edit `ARG JAVA_VERSION` in `Dockerfile` (e.g., `25-graalce`)
2. Update the version in this `README.md` (see [Versions](#versions))
3. Test with `./bin/build.sh` before tagging

---

## Versions

| Tag                | GraalVM Version   | Architectures         |
|--------------------|------------------|----------------------|
| `latest`           | 25-graalce       | amd64, arm64         |
| `25-graalce`       | 25-graalce       | amd64, arm64         |
| `24.0.2-graalce`   | 24.0.2-graalce   | amd64, arm64         |

See [Docker Hub](https://hub.docker.com/r/softinstigate/graalvm/tags) for all tags.

---

## Details

### SDKMAN Integration

- Installed at `/root/.sdkman`
- Config: `auto_answer=true`, `auto_selfupdate=false`, `insecure_ssl=true`
- Entrypoint sources bashrc so `sdk` and `java` are available
- Cleans up archives/tmp after install

### Multi-Architecture Support

- Images built for `linux/amd64` and `linux/arm64` via Docker Buildx (QEMU in CI)
- Local builds default to host architecture

### Shell Environment

- `SHELL ["/bin/bash", "-i", "-c"]` enables interactive bash for SDK commands
- Entrypoint: `source /root/.bashrc && "$@"` ensures environment is loaded

---

## CI/CD

- Triggers only on **tag pushes** (not regular commits)
- Can be skipped with `[skip ci]` in commit message

---

## Troubleshooting

- **Multi-arch issues**: Ensure all base images support both `amd64` and `arm64`.
- **Tagging**: `latest` always points to the most recent GraalVM version.

---

## License

Licensed under the [Apache 2.0 License](LICENSE).
