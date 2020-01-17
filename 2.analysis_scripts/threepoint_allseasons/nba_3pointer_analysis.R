library(tidyverse)
library(here)
# Example for Jags-Ybinom-XnomSsubjCcat-MbinomBetaOmegaKappa.R 
#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
graphics.off() # This closes all of R's graphics windows.
rm(list=ls())  # Careful! This clears all of R's memory!
#------------------------------------------------------------------------------- 
# Load the relevant model script into R's working memory:
source("./2.analysis_scripts/base_scripts/Jags-Ybinom-XnomSsubjCcat-MbinomBetaOmegaKappa.R")
#------------------------------------------------------------------------------- 
# Optional: Specify filename root and graphical format for saving output.
# Otherwise specify as NULL or leave saveName and saveType arguments 
# out of function calls.
fileNameRoot = "./2.analysis_scripts/threepoint_allseasons/output/ThreePointers-" 
graphFileType = "png" 
#------------------------------------------------------------------------------- 
# # Read past MCMC data
# load(file = "./2.analysis_scripts/threepointpercentage_analysis/output/ThreePointers-Mcmc.Rdata")
# mcmcCoda = codaSamples
# rm(codaSamples)
#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
base_year <- 2003

for (i in 1:6) {
  
  # Create MCMC data
  year1 <- base_year + i
  year2 <- year1 + 1
  file_name <- paste0("./0.data/NBA_reg_", year1,"-", year2,".csv")
  
  # Read the data 
  myData = read.csv(file_name)
  
  # Rounding 3 point attempts/made per game by total number of games played in season
  myData <- myData %>% mutate(tot_3pm = round(GP *X3PM), tot_3pa = round(GP *X3PA))
  
  # mcmc generation
  mcmc_year <- paste0("mcmc_",year1)
  assign(mcmc_year, genMCMC(data=myData , 
                                zName="tot_3pm", NName="tot_3pa", sName="PLAYER", cName="POS",
                                numSavedSteps=1000 , 
                                saveName=paste0(fileNameRoot,year1,"-") ,
                                thinSteps=100))
  # # summary statistics
  # smryMCMC( mcmc_2010 , compVal=NULL , 
  #           # diffSVec=c(75,156, 159,844) , 
  #           # diffCVec=c(1,2,3) , 
  #           compValDiff=0.0 , saveName=fileNameRoot )
  print(paste0("round ",i," is done!"))
  #------------------------------------------------------------------------------- 
} 
