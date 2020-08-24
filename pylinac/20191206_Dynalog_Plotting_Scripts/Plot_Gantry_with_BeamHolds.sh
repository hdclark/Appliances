#!/usr/bin/env bash

for dlgfile in *dlg ; do 
    tmpdir=$(mktemp -d /tmp/OK_to_delete_XXXXXXX)
    cat "${dlgfile}" | tail -n +7 | tr ',' ' ' > "${tmpdir}/dlg_data"
    dos2unix "${tmpdir}/dlg_data"

cat << EOF > "${tmpdir}/do.gnuplot"
        #set datafile sep ','
        set grid
        set ylabel 'Gantry Angle (BeamHolds Colourized)'
        set xlabel 'Row Number'
        set title 'Gantry angle vs DLG row number (BeamHolds colourized; ${dlgfile})'
        set term pdfcairo enhanced color solid size 7.5in,5.5in
        set output '${tmpdir}/Gantry_Colorized_BeamHolds.pdf'
        plot '${tmpdir}/dlg_data' u 0:7:4 w l palette lw 5 t ''
        set term pop
        #pause 10 
        #pause mouse keypress "Press any keyboard button on the active window to terminate\n"
EOF

    gnuplot -c "${tmpdir}/do.gnuplot"
    echo ""

    # Hoist the pdf out of the temp directory.
    cp "${tmpdir}/"Gantry_Colorized_BeamHolds*pdf "${dlgfile}_gantry_plot.pdf"

    # Remove working directory.
    #rm -rf "${tmpdir}"

done # dlgfile

