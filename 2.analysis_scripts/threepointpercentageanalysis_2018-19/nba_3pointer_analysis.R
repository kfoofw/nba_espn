library(tidyverse)
library(here)
# Example for Jags-Ybinom-XnomSsubjCcat-MbinomBetaOmegaKappa.R 
#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
graphics.off() # This closes all of R's graphics windows.
rm(list=ls())  # Careful! This clears all of R's memory!
#------------------------------------------------------------------------------- 
# Read the data 
myData = read.csv("./0.data/NBA_reg_2018-2019.csv")

# Rounding 3 point attempts/made per game by total number of games played in season
myData <- myData %>% mutate(tot_3pm = round(GP *X3PM), tot_3pa = round(GP *X3PA))
#------------------------------------------------------------------------------- 
# Load the relevant model script into R's working memory:
source("./2.analysis_scripts/base_scripts/Jags-Ybinom-XnomSsubjCcat-MbinomBetaOmegaKappa.R")
#------------------------------------------------------------------------------- 
# Optional: Specify filename root and graphical format for saving output.
# Otherwise specify as NULL or leave saveName and saveType arguments 
# out of function calls.
fileNameRoot = "./2.analysis_scripts/threepointpercentageanalysis_2018-19/output/ThreePointers-" 
graphFileType = "png" 
#------------------------------------------------------------------------------- 
# # Read past MCMC data
# load(file = "./2.analysis_scripts/threepointpercentage_analysis/output/ThreePointers-Mcmc.Rdata")
# mcmcCoda = codaSamples
# rm(codaSamples)
#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
startTime = proc.time()
mcmcCoda = genMCMC( data=myData , 
                    zName="tot_3pm", NName="tot_3pa", sName="PLAYER", cName="POS",
                    numSavedSteps=1000 , #saveName=fileNameRoot ,
                    thinSteps=100 )
stopTime = proc.time()
elapsedTime = stopTime - startTime
show(elapsedTime)
#------------------------------------------------------------------------------- 
# Display diagnostics of chain, for specified parameters:
parameterNames = varnames(mcmcCoda) # get all parameter names for reference
for ( parName in c("omegaO","kappaO","omega[1]","omega[2]","omega[3]","omega[4]","omega[5]","omega[6]","omega[7]","theta[1]") ) { 
  diagMCMC( codaObject=mcmcCoda , parName=parName , 
                saveName=fileNameRoot , saveType=graphFileType )
}
#------------------------------------------------------------------------------- 
# Get summary statistics of chain:
summaryInfo = smryMCMC( mcmcCoda , compVal=NULL , 
                        # diffSVec=c(75,156, 159,844) , 
                        # diffCVec=c(1,2,3) , 
                        compValDiff=0.0 , saveName=fileNameRoot )
# Display posterior information:
plotMCMC( mcmcCoda , data=myData , 
          zName="tot_3pm", NName="tot_3pa", sName="PLAYER", cName="POS",
          compVal=NULL ,
          diffCList=list( c("PG","SG") ,
                          c("SF","PF") ,
                          c("C","PG")  ,
                          c("PF", "PG"),
                          c("PF", "G")) ,
          diffSList=list( c("James Harden","Karl-Anthony Towns") ,
                          c("Stephen Curry","Jusuf Nurkic")) ,
          compValDiff=0.0, #ropeDiff = c(-0.05,0.05) ,
          saveName=fileNameRoot , saveType=graphFileType )
#------------------------------------------------------------------------------- 
