#!/bin/bash

# This script provides a git-annex accessible via ssh that serves everything within a given root directory.

exposed_dir_root="/media/sarah/"

image_basename="git-annex"
ssh_root_dir="${HOME}/.ssh/"


# Scrape local DNS nameservers for use in the container.
DNS_ARGS=()
while read -r -u 9 url ; do
    DNS_ARGS+=("--dns ${url}")
done 9< <( sed -n -e 's/^nameserver //p' /etc/resolv.conf ; 
           printf '8.8.8.8\n8.8.4.4\n' 
         )

set -e 

sudo docker run \
    -dit \
    --memory 16G \
    --cpus 8 \
    --restart always \
    `# ` \
    `# ` \
    `# Attach mutable state in /media.` \
    -v "${exposed_dir_root}":/mnt/:rw \
    `# ` \
    `# Ensure the local DNS (including LAN addresses) are honoured.` \
    ${DNS_ARGS[@]} \
    `# ` \
    `# ` \
    `# Inherit ssh credentials from the local host and expose the sshd service.` \
    -p 2222:22 \
    -v "${ssh_root_dir}":/.ssh_prototype/:ro \
    `# ` \
    --name gitannex_media \
    "${image_basename}":latest 

#    --rm --it
#    --entrypoint /bin/bash \


printf "\n"
printf "  Container launched.\n"
printf "  To inspect stdout:\n"
printf "      sudo docker logs gitannex_media\n"
printf "  To stop/restart issue:\n"
printf "      sudo docker container stop gitannex_media\n"
printf "      sudo docker container start gitannex_media\n"
printf "      sudo docker container restart gitannex_media\n"
printf "  The container will persist between starting and stopping.\n"
printf "  To take a snapshot the container as a new image issue:\n"
printf "      sudo docker commit gitannex_media newname\n"
printf "  To delete the image:\n"
printf "      sudo docker container stop gitannex_media\n"
printf "      sudo docker container rm gitannex_media\n"
printf "\n"

