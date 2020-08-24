#!/bin/bash

image_basename="rstats"

set -e 

artifacts_dir="${HOME}/${image_basename}_container_artifacts/"
mkdir -p "${artifacts_dir}"

printf -- "${image_basename} container artifacts going to: ${artifacts_dir}\n" 1>&2

sudo docker run \
    -it \
    --rm \
    -v "$(pwd)":/start/:rw \
    -v "${artifacts_dir}":/artifacts/:rw \
    -w /start \
    "${image_basename}":latest \
    $@

#    -p 8080:80 \
#    --entrypoint /bin/bash \


rmdir "${artifacts_dir}" &>/dev/null || \
    printf -- "${image_basename} container artifacts remain in ${artifacts_dir}\n" 1>&2

