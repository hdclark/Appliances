#!/bin/bash


#!/bin/bash

k=9050
j=Set_032     # <---- Figure out which phase you want by grepping for 'Series Description' and 'PN:??'.

for i in Set_* ; do
    nice -n 15   ionice -c 3 \
      /home/hal/Dropbox/Code/Register_Liver_Perfusion.sh -r "$j" -d "$i" \
           -o Registered_"$i"_to_"$j" \
           -p command_file.txt \
           -s "$k" \
           -c 'Registered to first-pass VHS Phase PN:33.'
done

