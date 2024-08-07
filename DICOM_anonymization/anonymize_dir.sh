#!/usr/bin/env bash

# This script anonymizes a directory of DICOM files.
#
# It follows *most* of DICOM supplement 142 "Clinical Trial De-Identification."
#
# It correctly handles all the 'potentially problematic' tags described in the study by Aryanto et al. 2015
# (doi:10.1007/s00330-015-3794-0).
#
# All files in the directory are assumed to comprise a logical set (i.e., all files correspond to a single patient). All
# output files are assigned uniform series and study information.
#
# Note: The input must be in a directory at the top-level.
#
# Note: This program is interactive but will use command-line parameters if provided.
#
# Note: This program is ad-hoc and does not fully conform to the DICOM standard. Use at your own risk.
#

set -eu

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
anondir=""

AnonLevel="full"

###########################################################################################
# Argument parsing
###########################################################################################
OPTIND=1 # Reset in case getopts has been used previously in the shell.
while getopts "hup:s:n:t:e:a" opt; do
    case "$opt" in
    u)  true
        ;&
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
        printf '\t   -p "new_anonymous_patient_id"    `# Optional; will be queried if missing.` \\\n'
        printf '\t   -n "new_anonymous_patient_name"  `# Optional; will be queried if missing.` \\\n'
        printf '\t   -s "new_anonymous_study_id"      `# Optional; will be queried if missing.` \\\n'
        printf '\t   -t "new_anonymous_study_desc"    `# Optional; will be queried if missing.` \\\n'
        printf '\t   -e "new_anonymous_series_desc"   `# Optional; will be queried if missing.` \\\n'
        printf '\t   -a                               `# Optional; use partial anonymization.` \\\n'
        printf '\t   "dir_with_dicom_artifacts_from_one_patient/" \\\n'
        printf '\t   "output_dir/"\n'
        printf '\n'
        printf 'Note: \n'
        printf '\t By default a full anonymization is performed. A "partial" mode, which **may**\n'
        printf '\t leave some fields containing identifying information, can be enabled by\n'
        printf '\t supplying the "-a" option. Partial mode is useful when full anonymization\n'
        printf '\t strips away information that is critical for later analysis.\n\n'
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
    a)  AnonLevel="partial"
        ;;
    esac
done
shift $(( OPTIND - 1 ))  # Purge all consumed options to the left of the first non-option token.

if [ "$#" -lt 2 ] ; then
    printf 'Directories not provided. Refusing to continue.\n' 1>&2
    exec "$0" -h
    exit 1
fi

# Determine which directories to use.
#
# Note: the following loop deals with directories that have spaces.
while [ ! -d "${thedir}" ] ; do
    if [ -z "${thedir}" ] ; then
        thedir="$1"
    else
        thedir+="${thedir} $1"
    fi
    shift
    if [ "$#" -eq 0 ] ; then
        break
    fi
done
thedir="${thedir%/}" # Strip any trailing '/' to avoid confusing rsync or Docker.
thedir="$(realpath -m "${thedir}")" # Resolve full path.
if [ ! -d "${thedir}" ] ; then
    printf 'Cannot access directory "%s". Refusing to continue.\n' "${thedir}" 1>&2
    exit 1
fi
printf 'Continuing with input directory "%s".\n' "${thedir}"

anondir="$@"
anondir="${anondir%/}" # Strip any trailing '/' to avoid confusing rsync or Docker.
if [ -z "${anondir}" ] ; then
    printf "No output directory provided. Cannot continue\n" 2>&1
    exit 1
fi

# Poll for missing info.
if [ -z "${PatientIDProvided}" ] ; then 
    printf "Patient ID? (e.g., 'anon_1234')\n"
    candidate="anon_$RANDOM$RANDOM"
    read -t 300 -e -i "${candidate}" PatientID || PatientID="${candidate}"
    PatientIDProvided="yes"
fi

if [ -z "${StudyIDProvided}" ] ; then 
    printf "Study ID? (e.g., '1234')\n"
    candidate="${RANDOM}0"
    read -t 300 -e -i "${candidate}" StudyID || StudyID="${candidate}"
    StudyIDProvided="yes"
fi

if [ -z "${PatientsNameProvided}" ] ; then 
    printf "Patient's name? (e.g., 'Anonymous^Anonymous')\n"
    candidate="${PatientID}^${PatientID}"
    read -t 300 -e -i "${candidate}" PatientsName || PatientsName="${candidate}"
    PatientsNameProvided="yes"
fi

if [ -z "${StudyDescProvided}" ] ; then 
    printf "Study description? (e.g., 'Research study for X.').\n"
    printf "    Note: No quotes are needed.\n"
    if [ "${AnonLevel}" == "full" ] ; then
        printf "    Note: Leave empty to overwrite with an empty value.\n"
    else
        printf "    Note: Leave empty to retain existing description.\n"
    fi
    if  read -t 300 StudyDesc  ; then 
        StudyDescProvided="yes"
    else
        StudyDesc=""
        StudyDescProvided=""
    fi
fi

if [ -z "${SeriesDescProvided}" ] ; then 
    printf "Series description? (e.g., 'Research scan for Y.').\n"
    printf "    Note: No quotes are needed.\n"
    if [ "${AnonLevel}" == "full" ] ; then
        printf "    Note: Leave empty to overwrite with an empty value.\n"
    else
        printf "    Note: Leave empty to retain existing description.\n"
        printf "    Note: Setting this option will cause **all** descriptions to be overwritten with the same value.\n"
    fi
    if  read -t 300 SeriesDesc  ; then
        SeriesDescProvided="yes"
    else
        SeriesDesc=""
        SeriesDescProvided=""
    fi
fi

if [ "${AnonLevel}" == "full" ] ; then
    InternalAnonScript="/usr/bin/anonymize"
else
    InternalAnonScript="/usr/bin/anonymize_partial"
fi

# Ensure we have necessary info.
if [ -z "$PatientIDProvided" ] \
|| [ -z "$StudyIDProvided" ] \
|| [ -z "$PatientsNameProvided" ] ; then
    printf "This script currently requires all name and ID parameters to be specified. Refusing to continue.\n" 2>&1
    exit 1
fi

# Ensure the output directory exists and is accessible.
anondir="$(realpath -m "${anondir}")" # Resolve full path.
mkdir -pv "${anondir}"
if [ ! -d "${anondir}" ] ; then
    printf "Output directory not accessible. Cannot continue\n" 2>&1
    exit 1
fi
#printf -- "Anonymizing '${thedir}' to '${anondir}' ...\n"

set -x

# Perform the anonymization.
#time \
sudo \
docker \
  run \
    -it --rm \
    -v "${thedir}":/input/:ro \
    -v "${anondir}":/output/:rw \
    \
    dcm_anon:latest \
    "${InternalAnonScript}" \
      -p "${PatientID}" \
      -s "${StudyID}" \
      -n "${PatientsName}" \
      ` [ ! -z "${StudyDescProvided}" ]  && printf -- ' -t "%s"' "${StudyDesc}" ` \
      ` [ ! -z "${SeriesDescProvided}" ] && printf -- ' -e "%s"' "${SeriesDesc}" ` 

sudo \
chown -R --reference="${thedir}" "${anondir}"

