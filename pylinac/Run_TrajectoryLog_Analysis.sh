#!/usr/bin/env bash

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"
cd "${script_dir}"

if [ ! -d /tmp/tlogs ] ; then
    printf 'Create "/tmp/tlogs/" and place trajectory log files (*.bin) inside before proceeding.\n' 2>&1
    exit 1
fi

logfiles=(/tmp/tlogs/*bin)
if [[ ! -f "${logfiles[0]}" ]] ; then
    printf 'Unable to locate binary trajectory log files (*.bin) in "/tmp/tlogs/".\n' 2>&1
    exit 1
fi

./Run_Container.sh python3 ./Analyze_TrajectoryLog.py

printf 'Outputs will be found in "/tmp/tlogs/".\n'

