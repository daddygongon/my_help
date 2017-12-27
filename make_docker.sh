#!/bin/sh

sed "/FROM alpine:3.7/a\\
\nENV http_proxy '$http_proxy'\\
ENV https_proxy '$https_proxy'" Dockerfile.template > Dockerfile