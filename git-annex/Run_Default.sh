#!/bin/bash

# This script will act like a simplistic init process inside the container, setting up the runtime environment and
# launching necessary programs. It is invoked by default, but can be overridden when launching the container.

set -e

git annex version

rsync -a /.ssh_prototype/ /home/hal/.ssh/
rsync -a /.ssh_prototype/ /root/.ssh/
chown --recursive hal:users /home/hal/.ssh/
chown --recursive root:root /root/.ssh/

mkdir -p /run/sshd  # Needs to exist for privilege separation.

set +e 

while true ; do 
    /usr/sbin/sshd -D # or -d for verbosity.

    printf " ==== Restarting sshd shortly... ==== \n"
    sleep 0.5
done


