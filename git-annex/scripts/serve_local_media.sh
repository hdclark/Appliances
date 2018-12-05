#!/bin/bash

# This script provides git-annex accessible by ssh that serves everything in /media/.

exposed_dir_root="/media/"

image_basename="git-annex"
ssh_root_dir="${HOME}/.ssh/"

set -e 

sudo docker run \
    -it --rm \
    `# ` \
    `# ` \
    `# Attach mutable state in /media.` \
    -v "${exposed_dir_root}":"${exposed_dir_root}":rw \
    `# ` \
    `# ` \
    `# Inherit ssh credentials from the local host and expose the sshd service.` \
    -p 2222:22 \
    -v "${ssh_root_dir}":/root/.ssh/:ro \
    -v "${ssh_root_dir}":/home/hal/.ssh/:ro \
    `# ` \
    "${image_basename}":latest

