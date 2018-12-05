#!/bin/bash

image_basename="git-annex"

set -e 

sudo docker run \
    -it \
    --rm \
    -p 2222:22 \
    -v "$(pwd)":/scratch/:rw \
    -w /scratch/ \
    "${image_basename}":latest \
    $@

#    -w /scratch/ \
#    -p 8080:80 \
#    --entrypoint /bin/bash \

