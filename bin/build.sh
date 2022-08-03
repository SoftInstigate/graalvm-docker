#!/bin/bash

docker build --build-arg JAVA_VERSION="22.2.r17-grl" --no-cache . -t softinstigate/graalvm 
docker tag softinstigate/graalvm:latest softinstigate/graalvm:latest
