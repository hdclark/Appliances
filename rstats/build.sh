#!/bin/bash

set -e 

image_basename="rstats"

commit_id=$(git rev-parse HEAD)

clean_dirty="clean"
sstat=$(git diff --shortstat)
if [ ! -z "${sstat}" ] ; then
    clean_dirty="dirty"
fi

build_datetime=$(date '+%Y%m%_0d-%_0H%_0M%_0S')

#reporoot=$(git rev-parse --show-toplevel)
#cd "${reporoot}"

time sudo docker build \
    --no-cache=true \
    -t "${image_basename}":"built_${build_datetime}" \
    -t "${image_basename}":"commit_${commit_id}_${clean_dirty}" \
    -t "${image_basename}":latest \
    --build-arg DOCKER_CACHE_BREAKER="$(date +%s)" \
    -f ./Dockerfile \
    .

