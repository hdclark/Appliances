#!/bin/bash

#cd /resources/CT_to_CT_deformable/

cf=""
if [ -f /command_file.txt ] ; then
    printf 'Using provided command file rather than the default command file.\n'
    cf="/command_file.txt"
else
    printf 'Using default command file.\n'
    cf="/resources/CT_to_CT_deformable/command_file.txt"
fi

plastimatch register "$cf"


