#!/bin/bash

# Run the anonymize_partial script on the mapped directory.
#
# It will be run on all directories present.
#
find /artifacts/ \
  -mindepth 1 -maxdepth 1 \
  -type d \
  \! -iname '*_anon' \
  -exec printf "\n\nAnonymizing files in directory '{}'...\n" \; \
  -exec anonymize_partial '{}' \; \
  -exec chown --recursive --reference='{}' '{}'_anon \;

