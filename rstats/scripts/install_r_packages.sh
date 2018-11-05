#!/usr/bin/env r

templibloc <- '/usr/local/lib/R/site-library'  # See '.libPaths()' output.
dir.create(templibloc, showWarnings = FALSE, recursive = TRUE)

for(package in c( "relaimpo",                                                                   
                  "modeltools",                                                                 
                  "strucchange",                                                                
                  "party",                                                                      
                  "nlstools",                                                                   
                  "tidyverse",                                                                  
                  "readxl" )){                                                                  
    if(!require(package, character.only=T, quietly=T, warn.conflicts=F, lib.loc=templibloc)){   
        install.packages(package, repos='http://cran.rstudio.com/',                             
                                  dependencies=T,                                               
                                  verbose=F, quiet=T, lib=templibloc)                           
        library(package, character.only=T, quietly=T, verbose=F, lib.loc=templibloc)            

        if(!require(package, character.only=T, quietly=T, warn.conflicts=F, lib.loc=templibloc)){
            cat("Unable to install package. Terminating with non-zero exit status.\n")
            quit(save="no", status=1)
        }
    }                                                                                           
}                                                                                               

quit(save="no", status=0)

