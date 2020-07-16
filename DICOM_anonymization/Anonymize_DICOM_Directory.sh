#!/bin/bash

userATremote="hal@localhost"  # Point to localhost.

PatientID=""
StudyID=""
PatientsName=""
StudyDesc=""
SeriesDesc=""

PatientIDProvided=""  # Non-empty if provided by a command-line argument.
StudyIDProvided=""
PatientsNameProvided=""
StudyDescProvided=""
SeriesDescProvided=""

thedir=""

###########################################################################################
# Argument parsing
###########################################################################################
OPTIND=1 # Reset in case getopts has been used previously in the shell.
while getopts "hp:s:n:t:e:" opt; do
    case "$opt" in
    h)
        printf '\n'
        printf '===============================================================================\n'
        printf 'This script anonymizes a directory of DICOM files.\n'
        printf 'All files will be assumed to belong to the same patient and will remain linked.\n'
        printf '\n'
        printf 'This script will poll you for any missing top-level information.\n'
        printf 'Providing command-line arguments will disable polling for the given parameter.\n'
        printf 'Providing all needed top-level information works best for automation!\n'
        printf '\n'
        printf 'Usage: \n'
        printf '\t '"$0"' \\\n'
        printf '\t   -p "new_anonymous_patient_id" \\\n'
        printf '\t   -n "new_anonymous_patient_name" \\\n'
        printf '\t   -s "new_anonymous_study_id" \\\n'
        printf '\t   -t "new_anonymous_study_desc" \\\n'
        printf '\t   -e "new_anonymous_series_desc" \\\n'
        printf '\t   "dir_with_dicom_artifacts_from_one_patient/"\n\n'
        printf '===============================================================================\n'
        exit 1
        ;;
    p)  PatientIDProvided="yes"
        PatientID="${OPTARG}"
        ;;
    s)  StudyIDProvided="yes"
        StudyID="${OPTARG}"
        ;;
    n)  PatientsNameProvided="yes"
        PatientsName="${OPTARG}"
        ;;
    t)  StudyDescProvided="yes"
        StudyDesc="${OPTARG}"
        ;;
    e)  SeriesDescProvided="yes"
        SeriesDesc="${OPTARG}"
        ;;
    esac
done
shift $(( OPTIND - 1 ))  # Purge all consumed options to the left of the first non-option token.

thedir="$@" # On localhost.
thedir=${thedir%/} # Strip any trailing '/' to avoid confusing rsync.
if [ ! -d "$thedir" ] ; then
    printf "Unable to access directory '${thedir}'. Cannot continue.\n" 2>&1
    exit 1
fi

if [ -z "$PatientIDProvided" ] \
|| [ -z "$StudyIDProvided" ] \
|| [ -z "$PatientsNameProvided" ] \
|| [ -z "$StudyDescProvided" ] \
|| [ -z "$SeriesDescProvided" ] ; then
    printf "This script requires all patient parameters to be provided. Refusing to continue.\n" 2>&1
    # Note: All params needed to be supplied because I can't selectively pass arguments (see below).
    #       Providing only some parameters would also make the script interactive, which this script isn't well suited
    #       for.
    exit 1
fi


lastdir=$( basename "$thedir" )         # On localhost.
anontopdir="/media/sf_U_DRIVE/to_anon"  # On remote.
anondir="${anontopdir}/in"              # On remote.
outdir="${thedir}/../${lastdir}_anon"   # On localhost.

if [ -d "${outdir}" ] ; then
    printf "Destination directory '${outdir}' exists. Refusing to continue.\n" 2>&1
    exit 1
fi

printf "Transferring files now...\n"
ssh -tt "${userATremote}" "
    sudo rm -rf \"${anontopdir}\"
    mkdir -p \"${anontopdir}\"
"

rsync -azzP --compress-level=9 --delete "${thedir}/" "${userATremote}":"${anondir}/"

printf "Launching anonymization now...\n"
ssh -tt "${userATremote}" "
    cd \"${anontopdir}\" &&
    time \
    sudo \
    docker \
      run \
        -it --rm \
        -v \"${anontopdir}\":/artifacts/:rw \
        dcm_anon:latest \
        /resources/Run_anonymize_partial.sh \
          -p '${PatientID}' \
          -s '${StudyID}' \
          -n '${PatientsName}' \
          -t '${StudyDesc}' \
          -e '${SeriesDesc}'
"

printf "Transferring files back now...\n"
rsync -rvPzz --compress-level=9 --size-only --inplace "${userATremote}":"${anontopdir}/in_anon/" "${outdir}/" 

ssh -tt "${userATremote}" "
    sudo rm -rf \"${anontopdir}\"
"

