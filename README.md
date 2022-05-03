# graalvm-maven-docker

A docker image for [GraalVM](https://graalvm.org) built with [sdkman](https://sdkman.io) used at [SoftInstigate](https://softinstigate.com) to run [RESTHeart](https://restheart.org) on GraalVM.

Images are automatically published on [Docker Hub](https://hub.docker.com/r/softinstigate/graalvm).

## Versions ##

- GraalVM: 22.1.0.r17-grl
<<<<<<< HEAD

To add a new GraalVM version, just edit the JAVA_VERSION env variable in the [build action](https://github.com/SoftInstigate/graalvm-docker/blob/master/.github/workflows/docker-image.yml).
=======
>>>>>>> :arrow_up: Upgrade GraalVM to v22.1.0.r17-grl

## Run Java ##

```bash
$ docker pull softinstigate/graalvm
$ docker run -it --rm \
    -v "$PWD":/opt/app  \
    softinstigate/graalvm \
    java -jar /opt/app/myapp.jar
```
