#!/usr/bin/env bash

image_basename="docutools"

set -e 

sudo docker run \
    -it \
    --rm \
    -v "$(pwd)":"$(pwd)":rw \
    -w "$(pwd)" \
    "${image_basename}":latest \
    $@

#    -w /scratch/ \
#    -p 8080:80 \
#    --entrypoint /bin/bash \

