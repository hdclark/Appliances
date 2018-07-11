#!/bin/bash

###########################################################################################
# Figure out which command file to use.
###########################################################################################
#cd /resources/CT_to_CT_deformable/

cf=""
if [ -f /command_file.txt ] ; then
    printf 'Using provided command file rather than the default command file.\n'
    cf="/command_file.txt"
else
    printf 'Using default command file.\n'
    cf="/resources/CT_to_CT_deformable/command_file.txt"
fi

###########################################################################################
# Perform the registration.
###########################################################################################
printf '#### Invoking plastimatch now. ####\n'
plastimatch register "$cf"

sync

###########################################################################################
# Re-sync the metadata you want to keep to link the pre- and post-registered files.
#
# NOTE: This info was found by finding the superset of DICOM tag-values in the pre-deformed
#       image set. These tags should (hopefully, usually) be common for pre-deformed files.
###########################################################################################


# A routine to extract the modality from a DICOM file.
# Arguments:  array_of_files  array_of_DICOM_tags
#
# Examples:
#    thefiles=()
#    thefiles+=("somefile.dcm")
#    ...
#    tags=(Modality StudyInstaceUID)
#    get_keyvalue  thefiles tags
#
# Notes:
#   - Returns an empty string on failure.
#   - Each line contains one value. Multiple tags => multiple results.
#
get_keyvalue() {
    local -n impl_files=$1  # This is a reference to an array.
    local -n impl_keys=$2  # This is a reference to an array.

    l_invocation=()
    l_invocation+=(dcmdump)
    l_invocation+=(--quiet)
    l_invocation+=(--print-tree)
    l_invocation+=(--quote-as-octal)
    l_invocation+=(--ignore-errors)
    l_invocation+=(--search-all)
    for i in "${impl_keys[@]}" ; do
        l_invocation+=(--search)
        l_invocation+=("${i}")
    done
    for i in "${impl_files[@]}" ; do
        l_invocation+=("${i}")
    done
    "${l_invocation[@]}" |  # <--- invoked here!
        sed -e 's/[ ]*[(][0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][)] [A-Za-z][A-Za-z] //' \
            -e 's/[#][ ]*[0-9]*[,][ ][0-9]*[ ][A-Za-z]*.*//' \
            -e 's/.*\[//' -e 's/\].*//' -e '/^$/d'
}
export -f get_keyvalue

# A reference file selected from the inputs from which to extract pre-registration metadata.
first_file=$(find /moving/ -type f -iname '*dcm' -print -quit)
search_files=("${first_file}")


tags=('0008,0020') ; StudyDate=$(               get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:digit:]]' )
tags=('0008,0030') ; StudyTime=$(               get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:digit:]]' )
tags=('0008,0022') ; AcquisitionDate=$(         get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:digit:]]' )
tags=('0008,0032') ; AcquisitionTime=$(         get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:digit:]].' )
tags=('0020,000d') ; StudyInstanceUID=$(        get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:digit:]].' )
tags=('0008,0050') ; AccessionNumber=$(         get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )
tags=('0020,0052') ; FrameOfReferenceUID=$(     get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:digit:]].' )
#tags=('0020,0037') ; ImageOrientationPatient=$( get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )
tags=('0018,5100') ; PatientPosition=$(         get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )

ContentDate=$(date +%Y%m%d)
ContentTime=$(date +%H%M%S.%N)

tags=('0010,0010') ; PatientName=$(           get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )
tags=('0010,0020') ; PatientID=$(             get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' ) 
#tags=('0010,0040') ; Gender=$(                get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )
tags=('0008,0080') ; InstitutionName=$(       get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )
tags=('0008,0090') ; ReferringPhys=$(         get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )
tags=('0008,1010') ; StationName=$(           get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' | sed -r -e 's/[[:space:]]{2,}/ /g' )
tags=('0008,1030') ; StudyDescription=$(      get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' | sed -r -e 's/[[:space:]]{2,}/ /g' )
tags=('0008,103e') ; SeriesDescription=$(     get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )
tags=('0020,0010') ; StudyID=$(               get_keyvalue search_files tags | head -n 1 | tr -c -d '[[:alnum:]]' )

# Arbitrarily chosen, but hopefully unique in this dataset...
#SeriesNumber="9$(date +%N)"
SeriesNumber="$(date +%s)" 

# The following is an unsigned integer. A double may be spit out which needs to be trimmed of the decimal.
tags=('0020,9128') ; TemporalPositionIndex=$( get_keyvalue search_files tags | head -n 1 | sed -e 's/[.].*//g' | tr -c -d '[[:digit:]]' )

ImageComment="Image registered $(date +%Y%m%d-%H%M%S.%N)."

printf '#### Copying select metadata from pre-registration deformed images. ####\n'
find /outputs/ -type f -iname '*dcm' -exec \
dcmodify \
    --no-backup --verbose --padding-off \
    -i "(0008,0020)"="$StudyDate" \
    -i "(0008,0030)"="$StudyTime" \
    -i "(0008,0022)"="$AcquisitionDate" \
    -i "(0008,0032)"="$AcquisitionTime" \
    -i "(0020,000d)"="$StudyInstanceUID" \
    -i "(0008,0050)"="$AccessionNumber" \
    -i "(0020,0052)"="$FrameOfReferenceUID" \
    -i "(0018,5100)"="$PatientPosition" \
    -i "(0010,0010)"="$PatientName" \
    -i "(0010,0020)"="$PatientID" \
    -i "(0008,0080)"="$InstitutionName" \
    -i "(0008,0090)"="$ReferringPhys" \
    -i "(0008,1010)"="$StationName" \
    -i "(0008,1030)"="$StudyDescription" \
    -i "(0008,103e)"="$SeriesDescription" \
    -i "(0020,0011)"="$SeriesNumber" \
    -i "(0020,0010)"="$StudyID" \
    -i "(0020,9128)"="$TemporalPositionIndex" \
    -i "(0008,2111)"="$ImageComment" \
    -i "(0008,0023)"="$ContentDate" \
    -i "(0008,0033)"="$ContentTime" \
  '{}' \+ 2>&1

sync

printf '#### Embedding plastimatch command file into DICOM metadata of each file. ####\n'
find /outputs/ -type f -iname '*dcm' -exec \
dcmodify \
    --no-backup \
    -i "(0020,4000)"="Plastimatch file: $(cat ${cf} | tr '\n' ';')" \
  '{}' \+ 2>&1
    
sync


###########################################################################################
# Perform a sanity check of the outputs.
###########################################################################################
printf '#### Testing validity of output. ####\n'
find /outputs/ -type f -iname '*dcm' -exec \
dcmpschk \
  '{}' \+ 2>&1

printf "#### Note: tests are OFTEN failed for pedantic, irrelevant issues that don't affect the contemt. ####\n"


#  ###########################################################################################
#  # Create some derivations of the data.
#  ###########################################################################################
#  printf '#### Generating derived files. ####\n'
#  
#  find /outputs/ -type f -iname '*.dcm' -print0 |\
#      xargs -0 -I '{}' -P 3 -n 1 -r /home/hal/Dropbox/Code/Generate_missing_gdcmdump.sh '{}' 2>&1
#  
#  find /outputs/ -type f -iname '*.dcm' -print0 |\
#      xargs -0 -I '{}' -P 3 -n 1 -r /home/hal/Dropbox/Code/Generate_missing_dcmdump.sh '{}' 2>&1
#  
#  find /outputs/ -type f -iname '*.dcm' -print0 |\
#      xargs -0 -I '{}' -P 3 -n 1 -r /home/hal/Dropbox/Code/Render_DICOM_Image_CT_Lung.sh '{}' 2>&1

