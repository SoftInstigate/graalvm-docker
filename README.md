# graalvm-maven-docker

A docker image for [GraalVM](https://graalvm.org) built with [sdkman](https://sdkman.io) used at [SoftInstigate](https://softinstigate.com) to run [RESTHeart](https://restheart.org) on GraalVM.

Images are automatically published on [Docker Hub](https://hub.docker.com/r/softinstigate/graalvm).

## Versions ##

- GraalVM: 17.0.8-graal (23.0.1 for Java 17)

## Run Java ##

```bash
$ docker pull softinstigate/graalvm
$ docker run -it --rm \
    -v "$PWD":/opt/app  \
    softinstigate/graalvm \
    java -jar /opt/app/myapp.jar
```
