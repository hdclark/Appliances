#!/bin/bash

for dlgfile in *dlg ; do 
    tmpdir=$(mktemp -d /tmp/OK_to_delete_XXXXXXX)
    cat "${dlgfile}" | tail -n +7 | tr ',' ' ' > "${tmpdir}/dlg_data"
    dos2unix "${tmpdir}/dlg_data"

    for i in `seq 1 300` ; do

        j=$( printf '%03d' "$i" )
        #echo "$j"

cat << EOF > "${tmpdir}/do.gnuplot"
            #set datafile sep ','
            set grid
            set ylabel 'Column $j'
            set xlabel 'Row Number'
            set title 'Column $j vs row number'
            set term pdfcairo enhanced color solid size 7.5in,5.5in
            set output '${tmpdir}/Column_$j.pdf'
            plot '${tmpdir}/dlg_data' u 0:$i w l 
            set term pop
            #pause 10 
            #pause mouse keypress "Press any keyboard button on the active window to terminate\n"
EOF

        gnuplot -c "${tmpdir}/do.gnuplot"
        echo ""
    done # i

    # Remove empty pdfs.
    find "${tmpdir}/" -iname Column'*pdf' -empty -delete

    # Compile a single pdf of all the plots.
    pdftk "${tmpdir}/"Column_*pdf cat output "${dlgfile}_plots.pdf"

    # Remove working directory.
    #rm -rf "${tmpdir}"

done # dlgfile

