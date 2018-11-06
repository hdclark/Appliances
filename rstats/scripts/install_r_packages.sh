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

# Install the most up-to-date packages from GitHub.

p_unload(tidyverse)
#p_delete(tidyverse)  # Remove previous version so we can replace with github version.
#p_load_gh("tidyverse/tidyverse")
p_version(tidyverse)

p_unload(readxl)
p_delete(readxl)
#p_load_gh("tidyverse/readxl")
p_load_gh("tidyverse/readxl@e2b8f70")
p_version(readxl)

quit(save="no", status=0)

