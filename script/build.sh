#!/bin/bash
# Build docker images
export no_proxy=""
docker build -t movidius --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy movidius/ubuntu-18.04
