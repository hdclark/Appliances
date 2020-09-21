#!/usr/bin/env bash

image_basename="dcm_anon"

set -e 

artifacts_dir="${HOME}/${image_basename}_container_artifacts/"
mkdir -p "${artifacts_dir}"

printf -- "${image_basename} container artifacts going to: ${artifacts_dir}\n" 1>&2

sudo docker run \
    -it \
    --rm \
    -v "${artifacts_dir}":/artifacts/:rw \
    "${image_basename}":latest \
    $@

#   /resources/Run_anonymize.sh
#   /resources/Run_anonymize_partial.sh

#    -p 8080:80 \
#    --entrypoint /bin/bash \


rmdir "${artifacts_dir}" &>/dev/null || \
    printf -- "${image_basename} container artifacts remain in ${artifacts_dir}\n" 1>&2

