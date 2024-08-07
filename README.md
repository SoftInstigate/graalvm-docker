# graalvm-maven-docker

[![Docker Image CI](https://github.com/SoftInstigate/graalvm-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/SoftInstigate/graalvm-docker/actions/workflows/docker-image.yml)

A docker image for [GraalVM](https://graalvm.org) built with [sdkman](https://sdkman.io) used at [SoftInstigate](https://softinstigate.com) to run [RESTHeart](https://restheart.org) on GraalVM.

Images are automatically published on [Docker Hub](https://hub.docker.com/r/softinstigate/graalvm) when commit is tagged.

## Versions ##

- GraalVM: 21.0.2-graal

## Run Java ##

```bash
$ docker pull softinstigate/graalvm
$ docker run -it --rm \
    -v "$PWD":/opt/app  \
    softinstigate/graalvm \
    java -jar /opt/app/myapp.jar
```
