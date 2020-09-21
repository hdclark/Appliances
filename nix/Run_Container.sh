#!/usr/bin/env bash

image_basename="halclark/nix"

set -e 

sudo docker run \
    -it \
    --rm \
    --network=host \
    -v "$(pwd)":/scratch/:rw \
    -w /scratch/ \
    "${image_basename}":latest \
    $@

#    -w /scratch/ \
#    -p 8080:80 \
#    --entrypoint /bin/bash \

