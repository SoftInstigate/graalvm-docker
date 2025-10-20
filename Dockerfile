FROM debian:stable-slim

LABEL maintainer="SoftInstigate <info@softinstigate.com>"

ARG JAVA_VERSION="24.0.2-graalce"

ENV SDKMAN_DIR=/root/.sdkman

COPY bin/entrypoint.sh /root

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl locales unzip zip \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.UTF-8 \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && curl 'https://get.sdkman.io' | bash \
  && echo "sdkman_auto_answer=true" > "${SDKMAN_DIR}/etc/config" \
  && echo "sdkman_auto_selfupdate=false" >> "${SDKMAN_DIR}/etc/config" \
  && echo "sdkman_insecure_ssl=true" >> "${SDKMAN_DIR}/etc/config" \
  && chmod +x "${SDKMAN_DIR}/bin/sdkman-init.sh" \
  && bash -c "source ${SDKMAN_DIR}/bin/sdkman-init.sh \
  && sdk version \
  && sdk install java ${JAVA_VERSION} \
  && rm -rf ${SDKMAN_DIR}/archives/* \
  && rm -rf ${SDKMAN_DIR}/tmp/*"

WORKDIR /opt/app

SHELL ["/bin/bash", "-i", "-c"]

ENTRYPOINT [ "/root/entrypoint.sh" ]
