#!/bin/bash

# This script launches a plastimatch Docker container to apply a registration transformation to an RTDOSE file.
#
# NOTE: DICOM metadata may not be consistent. Post-processing may be needed!

# Parameters:
#   1. An RTDOSE file (to warp).
#   2. A transformation (vector file) produced by a previous registration.
#   3. Output directory.


# Variables, which must all be set by the input arguments:
deforming_dir=""  # The input directory containing DICOM files to be deformed/warped.
outgoing_dir=""   # The destination directory for warped files.
transform_file="" # A Plastimatch transformation file, typically in MHA format.
driver_file=""    # A driver script to use rather than the default.


# Argument parsing:
OPTIND=1 # Reset in case getopts has been used previously in the shell.
while getopts "hd:o:t:s:" opt; do
    case "$opt" in
    h)
        printf 'This script invokes a Plastimatch Docker container to warp DICOM RTDOSE images.\n' 
        printf '\n\n'
        printf "Usage: \n\t $0 -d 'Deformable_images/'" 
        printf               " -t 'Transformation.mha'"
        printf               " -o 'Warped/'"
        printf '\n\n'
        printf 'Optional: -s override_driver.sh'
        printf '\n\n'
        exit 0
        ;;
    d)  deforming_dir=$(realpath "$OPTARG")
        ;;
    o)  outgoing_dir="$OPTARG"
        ;;
    t)  transform_file=$(realpath "$OPTARG")
        ;;
    s)  driver_file=$(realpath "$OPTARG")
        ;;
    esac
done
#shift $((OPTIND-1))
#[ "$1" = "--" ] && shift
#echo "Leftover arguments: $@"


###########################################################################################
# Argument sanity-checking:
if [ ! -d "$deforming_dir" ] ; then
    printf 'Deforming directory not accessible. Cannot continue.\n'
    exit 1
fi
if [ -d "${outgoing_dir}/" ] ; then  # Note: significant '/' -- protects against empty string.
    printf 'Outgoing directory "%s" already exists. Cannot continue.\n' "${outgoing_dir}/"
    exit 1
fi
if [ ! -f "$transform_file" ] ; then
    printf 'Cannot access transform file. Cannot continue.\n'
    exit 1
fi
if [ ! -z "$driver_file" ] && [ ! -f "$driver_file" ] ; then
    printf 'Cannot access driver file. Cannot continue.\n'
    exit 1
fi


###########################################################################################
# Preparation of inputs for Plastimatch:
# (Note: The arrangement here must match that of the command file.)
set -e
mkdir -p "$outgoing_dir"/
set +e
log_file="$outgoing_dir"/warp_log.txt


invocation=()
invocation+=(docker)
invocation+=(run)
invocation+=(-it)
invocation+=(--rm)
invocation+=(-v)
invocation+=("$transform_file":/transform.mha:ro)
invocation+=(-v)
invocation+=("$deforming_dir":/moving/:ro)
invocation+=(-v)
invocation+=("$outgoing_dir":/outputs/:rw)
if [ ! -z "$driver_file" ] ; then
    invocation+=(-v)
    invocation+=("$driver_file":/Driver.sh:ro)
fi
invocation+=(plastimatch:latest)
if [ ! -z "$driver_file" ] ; then
    invocation+=(/Driver.sh)
else
    invocation+=(/resources/Warp_RTDOSE/Driver.sh)
fi


###########################################################################################
# Warp the images:
printf '### Warping now ###\n' | sudo tee -a "$log_file"

sudo "${invocation[@]}" 2>&1 | sudo tee -a "$log_file"
sync 

###########################################################################################
# Post-processing:
printf '### Post-processing now ###\n' | sudo tee -a "$log_file"

sudo chown --recursive hal:users "$outgoing_dir"/
sync 


