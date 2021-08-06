#!/bin/bash

docker build --build-arg JAVA_VERSION="21.1.0.r16-grl" --no-cache . -t softinstigate/graalvm 
docker tag softinstigate/graalvm:latest softinstigate/graalvm:latest