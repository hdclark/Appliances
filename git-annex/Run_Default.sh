#!/bin/bash

# This script will act like a simplistic init process inside the container, setting up the runtime environment and
# launching necessary programs. It is invoked by default, but can be overridden when launching the container.


git annex version

while true ; do 
    mkdir -p /run/sshd  # Needs to exist for privelege separation.
    /usr/sbin/sshd -D

    printf "Restarting sshd shortly...\n"
    sleep 0.5
done


