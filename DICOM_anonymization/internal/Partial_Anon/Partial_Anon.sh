#!/bin/bash

# This script is a convenience wrapper around the DICOM anonymization container. 
# Given a directory 'A' containing files like:
#   A/
#   A/B/
#   A/B/1.dcm
#   A/B/2.dcm
#   A/B/3.dcm
#   A/C/
#   A/C/1.dcm
#   A/C/2.dcm
#   A/C/3.dcm
#
# This script will produce anonymized output of the first-level directories like:
#   A/
#   A/B_anon/
#   A/B_anon/1.dcm
#   A/B_anon/2.dcm
#   A/B_anon/3.dcm
#   A/C_anon/
#   A/C_anon/1.dcm
#   A/C_anon/2.dcm
#   A/C_anon/3.dcm
#
# But note that the original files will be retained in the output directory.
# Also, any directory ending in '_anon' will NOT be anonymized.

parentdir="$@"
parentdir=$( realpath "$parentdir" )
if [ -z "$parentdir" ] ; then
    printf "No parent directory provided. Cannot continue.\n" 1>&2
    exit 1
fi

if [ ! -d "$parentdir" ] ; then
    printf "Unable to access parent directory. Cannot continue.\n" 1>&2
    exit 1
fi

time sudo docker run -it --rm -v "${parentdir}":/artifacts/:rw dcm_anon:latest /resources/Run_anonymize_partial.sh

