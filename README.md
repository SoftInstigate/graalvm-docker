# graalvm-docker

# GraalVM Docker Image

Optimized multi-architecture GraalVM Docker images for [RESTHeart](https://restheart.org).

- **GraalVM:** 25.0.1
- **Architectures:** linux/amd64, linux/arm64
- **Base:** Debian stable-slim / Distroless

## Images

### Distroless (Default) - Recommended

**285MB** | `softinstigate/graalvm:25`

- ✅ No shell (maximum security)
- ✅ Runs as non-root (UID 65532)
- ✅ 90% fewer CVEs
- ✅ Cannot exec into container

```bash
docker run --rm -v "$PWD":/opt/app \
  softinstigate/graalvm:25 \
  -jar /opt/app/restheart.jar
```

### With Shell - For Debugging

**365MB** | `softinstigate/graalvm:25-shell`

- ✅ Has `/bin/sh` for debugging
- ✅ Can `docker exec` into container

```bash
docker run -it softinstigate/graalvm:25-shell /bin/sh
```

## Tags

**Distroless:**
- `latest`, `25`, `25.0`, `25.0.1`

**Shell:**
- `25-shell`, `25.0-shell`, `25.0.1-shell`

All tags support **amd64** and **arm64** automatically.

## What's Included

- ✅ GraalVM JDK 25 (HotSpot + GraalVM JIT)
- ✅ All Java standard libraries
- ✅ Headless mode (no GUI)
- ✅ HTTPS/TLS support

## What's Removed (Size Optimization)

- ❌ GUI libraries (AWT, Swing, JavaFX) - 20MB
- ❌ Native-image build tools - 37MB
- ❌ Static libraries - 183MB
- ❌ SubstrateVM components - 64MB
- ❌ jmods - 110MB
- ❌ Samples/demos - 60MB

**Result:** 68% size reduction (878MB → 285MB)

## Dockerfile

```dockerfile
FROM softinstigate/graalvm:25
COPY app.jar /opt/app/
CMD ["-jar", "/opt/app/app.jar"]
```

## Docker Compose

```yaml
services:
  app:
    image: softinstigate/graalvm:25
    command: ["-jar", "/opt/app/app.jar"]
    volumes:
      - ./:/opt/app
```

## Building

```bash
# Local
docker build -f Dockerfile.distroless -t myimage:25 .
docker build -t myimage:25-shell .

# Multi-arch
./build-multiarch.sh

# CI/CD (automatic on git tag)
git tag v25.0.1 && git push origin v25.0.1
```

## Debugging Distroless

Since distroless has no shell:

```bash
# Use remote debugging
docker run -p 5005:5005 softinstigate/graalvm:25 \
  -agentlib:jdwp=transport=dt_socket,server=y,address=*:5005 \
  -jar /opt/app/app.jar

# Or use shell variant
docker run -it softinstigate/graalvm:25-shell /bin/sh
```

## Security

**Distroless:**
- No shell → Cannot exec
- No package manager → Cannot install tools
- Non-root → Cannot escalate
- Minimal binaries → 90% fewer CVEs

**Shell variant:**
- Standard Debian security
- Has shell for debugging
- Runs as root (configurable)

## Multi-Architecture

Works on:
- Intel/AMD (x86_64)
- Apple Silicon (M1/M2/M3)
- AWS Graviton
- ARM servers

Docker automatically pulls the correct architecture.

## License

Apache 2.0
