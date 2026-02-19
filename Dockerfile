# GraalVM Docker Image with Shell
# Multi-arch: linux/amd64, linux/arm64
# Expected size: ~365MB

FROM debian:stable-slim AS downloader

ARG GRAALVM_VERSION=25.0.2
ARG TARGETARCH

WORKDIR /tmp

# Map Docker's TARGETARCH to GraalVM's architecture naming
RUN case "${TARGETARCH}" in \
      amd64) echo "linux-x64" > /tmp/graalvm_arch ;; \
      arm64) echo "linux-aarch64" > /tmp/graalvm_arch ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
  && rm -rf /var/lib/apt/lists/*

# Download and extract GraalVM directly
RUN GRAALVM_ARCH=$(cat /tmp/graalvm_arch) \
  && curl -fsSL "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${GRAALVM_VERSION}/graalvm-community-jdk-${GRAALVM_VERSION}_${GRAALVM_ARCH}_bin.tar.gz" \
    -o graalvm.tar.gz \
  && mkdir -p /opt/graalvm \
  && tar -xzf graalvm.tar.gz -C /opt/graalvm --strip-components=1 \
  && rm graalvm.tar.gz

# Remove unnecessary components to save space
# Remove GUI libraries since RESTHeart is a server application
RUN cd /opt/graalvm \
  && rm -rf \
    lib/src.zip \
    lib/visualvm \
    lib/static \
    lib/svm \
    jmods \
    man \
    demo \
    sample \
    include \
  && cd lib \
  && rm -rf \
    libnative-image*.so \
    libawt*.so \
    libjavafx*.so \
    libprism*.so \
    libglass*.so \
    libfx*.so \
    libjfx*.so \
    libgstreamer*.so \
    libsplashscreen.so \
    libjavajpeg.so \
    libfontmanager.so \
    liblcms.so \
    libmlib_image.so \
    ct.sym \
    2>/dev/null || true

# Final stage
FROM debian:stable-slim

LABEL maintainer="SoftInstigate <info@softinstigate.com>"
LABEL description="GraalVM image with shell for debugging"
LABEL org.opencontainers.image.source="https://github.com/SoftInstigate/graalvm-docker"

# Copy only the JVM from builder
COPY --from=downloader /opt/graalvm /opt/graalvm

# Install minimal runtime dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    locales \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.UTF-8 \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/opt/graalvm
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV JAVA_OPTS="-Djava.awt.headless=true"

WORKDIR /opt/app

# Use shell entrypoint for flexibility
CMD ["/bin/sh"]
