#!/bin/bash

# This script launches a plastimatch Docker container to perform a deformable image registration.
#
# NOTE: DICOM metadata may not be consistent. Post-processing may be needed!

# Parameters:
#   1. Fixed images directory.
#   2. Moving images directory.
#   3. Output (registered) images and registration logs directory.
#   4. Optional: Plastimatch command file (else default is used).


# Variables, which must all be set by the input arguments:
reference_dir=""  # The input directory containing DICOM files which are treated as truth.
deforming_dir=""  # The input directory containing DICOM files to be deformed.
outgoing_dir=""   # The destination directory for registered files.
command_file=""   # A Plastimatch command file to use rather than the default.


# Default to use a bundled command file iff available.
export SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"
bundled_command_file="${SCRIPT_DIR}/command_file.txt"
if [ -f "${bundled_command_file}" ] ; then
    command_file="${bundled_command_file}"
fi


# Argument parsing:
OPTIND=1 # Reset in case getopts has been used previously in the shell.
while getopts "hr:d:o:c:" opt; do
    case "$opt" in
    h)
        printf 'This script invokes a Plastimatch Docker container to register DICOM images.\n' 
        printf '\n\n'
        printf "Usage: \n\t $0 -r 'Reference_images/' -d 'Deformable_images/'" 
        printf               " -o 'Registered_images/'"
        printf '\n\n'
        printf 'Optional: -c override_command_file.txt'
        printf '\n\n'
        exit 0
        ;;
    r)  reference_dir=$(realpath "$OPTARG")
        ;;
    d)  deforming_dir=$(realpath "$OPTARG")
        ;;
    o)  outgoing_dir="$OPTARG"
        ;;
    c)  command_file=$(realpath "$OPTARG")
        ;;
    esac
done
#shift $((OPTIND-1))
#[ "$1" = "--" ] && shift
#echo "Leftover arguments: $@"


###########################################################################################
# Argument sanity-checking:
if [ ! -d "$reference_dir" ] ; then
    printf 'Reference directory not accessible. Cannot continue.\n'
    exit 1
fi
if [ ! -d "$deforming_dir" ] ; then
    printf 'Deforming directory not accessible. Cannot continue.\n'
    exit 1
fi
if [ -d "${outgoing_dir}/" ] ; then  # Note: significant '/' -- protects against empty string.
    printf 'Outgoing directory "%s" already exists. Cannot continue.\n' "${outgoing_dir}/"
    exit 1
fi
if [ ! -z "$command_file" ] && [ ! -f "$command_file" ] ; then
    printf 'Cannot access command file. Cannot continue.\n'
    exit 1
fi


###########################################################################################
# Preparation of inputs for Plastimatch:
# (Note: The arrangement here must match that of the command file.)
set -e
mkdir -p "$outgoing_dir"/
set +e
log_file="$outgoing_dir"/registration_log.txt


invocation=()
invocation+=(docker)
invocation+=(run)
invocation+=(-it)
invocation+=(--rm)
invocation+=(-v)
invocation+=("$reference_dir":/fixed/:ro)
invocation+=(-v)
invocation+=("$deforming_dir":/moving/:ro)
invocation+=(-v)
invocation+=("$outgoing_dir":/outputs/:rw)
if [ ! -z "$command_file" ] ; then
    invocation+=(-v)
    invocation+=("$command_file":/command_file.txt:ro)
fi
invocation+=(plastimatch:latest)
invocation+=(/resources/CT_to_CT_deformable/Driver.sh)


###########################################################################################
# Register the images:
printf '### Registering now ###\n' | sudo tee -a "$log_file"

sudo "${invocation[@]}" 2>&1 | sudo tee -a "$log_file"
sync 

###########################################################################################
# Post-processing:
printf '### Post-processing now ###\n' | sudo tee -a "$log_file"

sudo chown --recursive hal:users "$outgoing_dir"/
sync 


