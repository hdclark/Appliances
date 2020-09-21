#!/usr/bin/env bash

# Run the anonymize script on the mapped directory.
#
# It will be run on all directories present.
#
# Note that all options will be passed through to the anonymization script, which will disable interactive polling for
# the provided parameters.
#
find /artifacts/ \
  -mindepth 1 -maxdepth 1 \
  -type d \
  \! -iname '*_anon' \
  -exec printf "\n\nAnonymizing files in directory '{}'...\n" \; \
  -exec anonymize "$@" '{}' \; \
  -exec chown --recursive --reference='{}' '{}'_anon \;

