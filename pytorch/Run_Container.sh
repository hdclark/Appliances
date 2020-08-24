#!/usr/bin/env bash

image_basename="pytorch"

set -eu

#export l_UID="$(id -u)"
#export l_GID="$(id -g)"
#export l_USER="$USER"

sudo docker run \
    -it \
    --rm \
    --network=host \
    -v "$(pwd):$(pwd):rw" \
    -v "/tmp/":"/tmp/":rw \
    -w "$(pwd)" \
    "${image_basename}":latest \
    $@

    #-v         "...":"/usr/local/lib/python3.7/dist-packages/pytorch/demo_files/Tlog.bin":ro \
    #-v "/tmp/in.dlg":"/usr/local/lib/python3.7/dist-packages/pytorch/demo_files/AQA.dlg":ro \
    #--user $l_UID:$l_GID \
    #--workdir="/home/$l_USER" \
    #--volume="/etc/group:/etc/group:ro" \
    #--volume="/etc/passwd:/etc/passwd:ro" \
    #--volume="/etc/shadow:/etc/shadow:ro" \


