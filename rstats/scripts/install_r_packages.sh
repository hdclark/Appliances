#!/usr/bin/env r

# Install the rstats 'pacman' package manager.
install.packages("pacman", 
                 repos='http://cran.rstudio.com/',                             
                 dependencies=T,                                               
                 verbose=F, 
                 quiet=T)

library("pacman", 
        character.only=T,
        quietly=T,
        verbose=F)

# Install other packages from the CRAN as necessary.
p_install(devtools)
p_install(relaimpo)
p_install(modeltools)
p_install(strucchange)
p_install(party)
p_install(nlstools)
p_install(tidyverse)
p_install(readxl)

quit(save="no", status=0)

