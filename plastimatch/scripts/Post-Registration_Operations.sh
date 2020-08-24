#!/usr/bin/env bash

# Note: Must be run at the top-level root of the registration, which should look like this:
#    
#    $> ls
#    command_file.txt Run.sh 
#    Registered_Set_000_to_Set_032 Registered_Set_001_to_Set_032 
#    Registered_Set_002_to_Set_032 Registered_Set_003_to_Set_032 
#    Registered_Set_004_to_Set_032 Registered_Set_005_to_Set_032 
#    Registered_Set_006_to_Set_032 Registered_Set_007_to_Set_032 
#    Registered_Set_008_to_Set_032 Registered_Set_009_to_Set_032 
#    Registered_Set_010_to_Set_032 Registered_Set_011_to_Set_032 
#    Registered_Set_012_to_Set_032 Registered_Set_013_to_Set_032 
#    Registered_Set_014_to_Set_032 Registered_Set_015_to_Set_032 
#    Registered_Set_016_to_Set_032 Registered_Set_017_to_Set_032 
#    Registered_Set_018_to_Set_032 Registered_Set_019_to_Set_032 
#    Registered_Set_020_to_Set_032 Registered_Set_021_to_Set_032 
#    Registered_Set_022_to_Set_032 Registered_Set_023_to_Set_032 
#    Registered_Set_024_to_Set_032 Registered_Set_025_to_Set_032 
#    Registered_Set_026_to_Set_032 Registered_Set_027_to_Set_032 
#    Registered_Set_028_to_Set_032 Registered_Set_029_to_Set_032 
#    Registered_Set_030_to_Set_032 Registered_Set_031_to_Set_032 
#    Registered_Set_032_to_Set_032 Registered_Set_033_to_Set_032 
#    Registered_Set_034_to_Set_032 Registered_Set_035_to_Set_032 
#    Registered_Set_036_to_Set_032 Registered_Set_037_to_Set_032 
#    Registered_Set_038_to_Set_032 Registered_Set_039_to_Set_032 
#    Registered_Set_040_to_Set_032 Registered_Set_041_to_Set_032 
#    Registered_Set_042_to_Set_032 
#    Set_000 Set_001 Set_002 Set_003 Set_004 
#    Set_005 Set_006 Set_007 Set_008 Set_009 Set_010 Set_011 Set_012 Set_013 Set_014 
#    Set_015 Set_016 Set_017 Set_018 Set_019 Set_020 Set_021 Set_022 Set_023 Set_024 
#    Set_025 Set_026 Set_027 Set_028 Set_029 Set_030 Set_031 Set_032 Set_033 Set_034 
#    Set_035 Set_036 Set_037 Set_038 Set_039 Set_040 Set_041 Set_042 
#
#  And the contents of Set_* are just CT files, and the content of Registered_* are
#    command_file.txt  Fixed  Moving  Registered  
#    registration_log.txt  stage_1_rigid.txt  stage_2_affine.txt
#    stage_3_itk_demons_vf.mha

#find ./ -type f -iname '*dump' -iwholename '*/Registered/*' -delete
#find ./ -type f -iname '*.dcm' -iwholename '*/Registered/*' -exec ~/Dropbox/Code/Generate_missing_gdcmdump.sh '{}' \;
#find ./ -type f -iname '*gdcmdump' -iwholename '*/Registered/*' -exec grep 'Series Instance' '{}' \; | sort | uniq -c
#find ./ -type f -iname '*gdcmdump' -iwholename '*/Registered/*' -exec grep 'Series Instance' '{}' \; 2>/dev/null | head -n 1

NewSeriesUID="$( find ./ -type f -iname '*.dcm' -iwholename '*/Registered/*' -exec dicomautomaton_dump '{}' 0020 000e \; -quit )"

if [ -z "$NewSeriesUID" ] ; then
    printf 'Unable to identify a suitable series UID to use. Cannot continue.\n' 1>&2
    exit 1
else
    printf "Using SeriesInstanceUID = '$NewSeriesUID'.\n"
fi

# Modify the UIDs to match.
find ./ -type f -iname '*.dcm' -iwholename '*/Registered/*' -exec dcmodify --no-backup -i "(0020,000e)"="$NewSeriesUID" '{}' \;

# Regenerate DICOM dumps.
find ./ -type f -iname '*dump' -iwholename '*/Registered/*' -delete
find ./ -type f -iname '*.dcm' -iwholename '*/Registered/*' -exec ~/Dropbox/Code/Generate_missing_gdcmdump.sh '{}' \;
#find ./ -type f -iname '*gdcmdump' -iwholename '*/Registered/*' -exec grep 'Series Instance' '{}' \; | sort | uniq -c


printf "Now examining the timestamps...\n"
find ./ -type f -iname '*gdcmdump' -iwholename '*/Registered/*' -exec grep 'Temporal Position Index' '{}' \; | sort | uniq -c
find ./ -type f -iname '*gdcmdump' -iwholename '*/Registered/*' -exec grep 'Derivation Description' '{}' \; | sort | uniq -c
find ./ -type f -iname '*gdcmdump' -iwholename '*/Registered/*' -exec grep 'Study Instance UID' '{}' \; | sort | uniq -c      # <--- Compare this!
find ./ -type f -iname '*gdcmdump' -iwholename '*/Registered/*' -exec grep 'Series Number' '{}' \; | sort | uniq -c


rm -rf */Fixed/
rm -rf */Moving/
#rm -rf Set_*
find ./ -type f \( -iname '*.png' -o -iname '*.jpg' \) -delete
find ./ -type f -iname '*gdcmdump' \! -iname *'dcm.gdcmdump' -iwholename '*/Registered/*' \! -iname '*dcm.gdcmdump' -exec rename gdcmdump dcm.gdcmdump '{}' \;
find ./ -type f -iname '*gdcmdump' \! -iname *'dcm.gdcmdump' -iwholename '*/Registered/*' \! -iname '*dcm.gdcmdump' -exec rename 's/gdcmdump/dcm.gdcmdump/g' '{}' \;
sync



printf "Remember, this series used the common SeriesInstanceUID = '$NewSeriesUID'.\n"

