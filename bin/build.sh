#!/bin/bash

docker build --no-cache . -t softinstigate/graalvm
docker tag softinstigate/graalvm:latest softinstigate/graalvm:latest
