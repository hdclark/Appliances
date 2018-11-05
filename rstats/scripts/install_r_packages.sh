#!/usr/bin/env r

libloc <- '/usr/local/lib/R/site-library'  # See '.libPaths()' output.
dir.create(libloc, showWarnings = FALSE, recursive = TRUE)

for(package in c( "relaimpo",                                                                   
                  "modeltools",                                                                 
                  "strucchange",                                                                
                  "party",                                                                      
                  "nlstools",                                                                   
                  "tidyverse",                                                                  
                  "readxl" )){                                                                  

    cat("==== Installing package", package, "as needed...\n")
    if(!require(package, character.only=T, quietly=T, warn.conflicts=F, lib.loc=libloc)){   
        install.packages(package, repos='http://cran.rstudio.com/',                             
                                  dependencies=T,                                               
                                  verbose=F, quiet=T, lib=libloc)                           
        library(package, character.only=T, quietly=T, verbose=F, lib.loc=libloc)            

        if(!require(package, character.only=T, quietly=T, warn.conflicts=F, lib.loc=libloc)){
            cat("Unable to install package. Terminating with non-zero exit status.\n")
            quit(save="no", status=1)
        }
    }                                                                                           
}                                                                                               

quit(save="no", status=0)

