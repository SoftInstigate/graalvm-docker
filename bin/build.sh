#!/bin/bash

docker build --build-arg JAVA_VERSION="22.1.0.r17-grl" --no-cache . -t softinstigate/graalvm 
docker tag softinstigate/graalvm:latest softinstigate/graalvm:latest
