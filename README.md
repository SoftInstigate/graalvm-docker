# graalvm-maven-docker

A docker image for [GraalVM](https://graalvm.org) built with [sdkman](https://sdkman.io) used at [SoftInstigate](https://softinstigate.com) to run [RESTHeart](https://restheart.org) on GraalVM.

## Versions ##

- GraalVM: 21.1.0.r16-grl

To add a new GraalVM version, just edit the JAVA_VERSION env variable in the [build action](https://github.com/SoftInstigate/graalvm-docker/blob/master/.github/workflows/docker-image.yml).

## Run Java ##

```bash
$ docker pull softinstigate/graalvm
$ docker run -it --rm \
    -v "$PWD":/opt/app  \
    softinstigate/graalvm \
    java -jar /opt/app/myapp.jar
```
