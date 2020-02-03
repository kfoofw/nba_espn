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
# Generate the MCMC chain:

generate_MCMC_for_years = function(base_year= 2018, 
                                   end_year = 2018,
                                   numSavedSteps = 50000,
                                   thinSteps=100) {
  
  year_diff <- end_year - base_year + 1
  # Generate MCMC Chain for each year
  for (i in 1:year_diff) {
    
    # Create MCMC data
    year1 <- base_year -1 + i
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
                              numSavedSteps=numSavedSteps ,
                              saveName=paste0(fileNameRoot,year1,"-") ,
                              thinSteps=100))
    # # summary statistics
    # smryMCMC( mcmc_2010 , compVal=NULL ,
    #           # diffSVec=c(75,156, 159,844) ,
    #           # diffCVec=c(1,2,3) ,
    #           compValDiff=0.0 , saveName=fileNameRoot )
    print(paste0("Year ",year_1," is done!"))
    
  }
}
# generate_MCMC_for_years(base_year = 2018, end_year = 2018, numSavedSteps = 1000, thinSteps = 100)
#------------------------------------------------------------------------------- 
rm(list=ls())  # To clear the unnecessary memory from generate_MCMC_for_years
source("./2.analysis_scripts/base_scripts/Jags-Ybinom-XnomSsubjCcat-MbinomBetaOmegaKappa.R")
fileNameRoot = "./2.analysis_scripts/threepoint_allseasons/output/ThreePointers-" 
graphFileType = "png"

omega_from_coda = function(base_year = 2018, end_year = 2018) {
  
  year_diff <- end_year - base_year + 1
  
  for (i in 1:year_diff) {
    # Set string variables
    year1 <- base_year -1 + i
    year2 <- year1 + 1
    file_name <- paste0("./0.data/NBA_reg_", year1,"-", year2,".csv")
    
    # Read the data
    myData = read.csv(file_name)
    
    # Read in stored Coda file
    load(file = paste0("./2.analysis_scripts/threepoint_allseasons/output/ThreePointers-",year1,"-Mcmc.Rdata"))
    mcmcMat = as.matrix(codaSamples, chains = TRUE)
    
    # Determine only relevant omega for C or PF. Appended last FALSE based on omegaO which is not in myData
    boolean_mask = c(levels(myData[["POS"]]) %in% c("C","PF"), FALSE)
    relevant_omega = sort(grep("omega",colnames(mcmcMat),value=TRUE))[boolean_mask]
    
    # Store to temp matrix object and rename it
    relevant_matrix = mcmcMat[,relevant_omega]
    colnames(relevant_matrix) <- c("C", "PF")
    
    # Store renamed colname matrix to object in environment. GlobalEnv settings
    assign(paste0("omega_",year1), relevant_matrix, envir = .GlobalEnv)
    
    print(get(paste0("omega_",year1)))
  }
}

omega_from_coda(base_year = 2017, end_year = 2018)
#------------------------------------------------------------------------------- 
# Plot the Omegas for the different years
plot_omegas = function(base_year = 2018, end_year = 2018,
                       compVal= NULL , rope=NULL , 
                       diffSList=NULL , diffCList=NULL , 
                       compValDiff=0.0 , ropeDiff=NULL , 
                       saveName=NULL , saveType="jpg" ){
  
  year_diff <- end_year - base_year + 1
  
  # Position Center plotting
  # Set string variables
  yearNames = mapply(function(x) {paste0(x, "_Center")}, paste0(seq(base_year, end_year)))
  nPanels = length(yearNames)
  nCols = 4
  nRows = ceiling(nPanels/nCols)
  openGraph(width=2.5*nCols,height=2.0*nRows)
  par( mfcol=c(nRows,nCols) )
  par( mar=c(3.5,1,3.5,1) , mgp=c(2.0,0.7,0) )
  #xLim = range( mcmcMat[,parNames] )
  mainIdx = 0
  for (i in 1:year_diff) {
      mainIdx = mainIdx+1
      year1 <- base_year -1 + i
      
      xLim=quantile(get(paste0("omega_", year1)),probs=c(0.001,0.999))
      postInfo = plotPost(get(paste0("omega_", year1))[,"C"], # mcmcMat[,parNames]
                          compVal=compVal , ROPE=rope ,
                           xlab=bquote(.("omega")) , cex.lab=1.25 , 
                           main=yearNames[[mainIdx]] , cex.main=1.5 ,
                           xlim=xLim , border="skyblue" )
  }
  if ( !is.null(saveName) ) {
    saveGraph( file=paste(saveName,"Omega_Center_",base_year, end_year, sep=""), type=saveType)
  }
    
  # Position PF plotting
  # Set string variables
  yearNames = mapply(function(x) {paste0(x, "_PF")}, paste0(seq(base_year, end_year)))
  nPanels = length(yearNames)
  nCols = 4
  nRows = ceiling(nPanels/nCols)
  openGraph(width=2.5*nCols,height=2.0*nRows)
  par( mfcol=c(nRows,nCols) )
  par( mar=c(3.5,1,3.5,1) , mgp=c(2.0,0.7,0) )
  #xLim = range( mcmcMat[,parNames] )
  mainIdx = 0
  for (i in 1:year_diff) {
    mainIdx = mainIdx+1
    year1 <- base_year -1 + i
    
    xLim=quantile(get(paste0("omega_", year1)),probs=c(0.001,0.999))
    postInfo = plotPost(get(paste0("omega_", year1))[,"PF"], # mcmcMat[,parNames]
                        compVal=compVal , ROPE=rope ,
                        xlab=bquote(.("omega")) , cex.lab=1.25 , 
                        main=yearNames[[mainIdx]] , cex.main=1.5 ,
                        xlim=xLim , border="skyblue" )
  }
  if ( !is.null(saveName) ) {
    saveGraph( file=paste(saveName,"Omega_PF_",base_year, end_year, sep=""), type=saveType)
  }

}
plot_omegas(base_year = 2017, end_year = 2018)
