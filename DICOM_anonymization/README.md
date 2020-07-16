
This appliance can be used to de-identify (anonymize) a directory containing DICOM artifacts (i.e., RTSTRUCTS, RTDOSE,
RTPLAN, RTRECORD, CT, MR, PET, etc.). This appliance is meant to be run in a `Linux` environment.

First, the `Docker` image needs to be built. This only needs to be done once.

    $>  ./build.sh

Then, gather the data for a single patient into one directory ("to-anonymize/").

    $>  mkdir -p to-anonymize/
    $>  cp 1.dcm 2.dcm 3.dcm ... to-anonymize/

Finally, run the following helper script to launch the docker image.

    $>  ./anonymize_dir.sh -a to-anonymize/ anonymized/

You will be asked to supply necessary information. It is possible to supply this information on the command line.
For more information see:

    $>  ./anonymize_dir.sh -h

