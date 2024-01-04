# ##################################
# 
# ####################################################################
# 
# Script: get_DataProducts.py
# Description: Tutorial on how to download and 
#              load the AMDOT-EXT data products
# Created: 29 Nov 2022 by Michael Hemming (NSW-IMOS)
# 
# using R version 3.6.1 (2019-07-05), RStudio interface
# 
# ######################################################################################################################
# 
# ####### Please cite the accompanying data set paper if you use the AMDOT-EXT data products #######
# 
# # ADD CITATION HERE
# 
# ######################################################################################################################
# 
# ##################################

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Import packages (These should be available on your system) --------------

library(ncdf4)

# If you do not currently have these packages installed, please use 'install.packages("package Name")'.


# -----------------------------------------------------------
# Download the data products

# The netCDF files are available for download here:
# http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html

# However, here we will load the file directly using OPeNDAP.

# For more information on the files and methodology, please see CITATION

## -----------------------------------------------------------
# load the data products
# We will use the Maria Island data product in this example

path <- 'C:\\Users\\z3526971\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Scripts\\Tutorials\\R\\';

# filename = 'http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html'
filename ='C:\\Users\\z3526971\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Data\\Finalised_data\\MAI090_TEMP_EXTREMES_1944-2022_v1.nc'

setwd(path)

# load file
data <- nc_open(filename)

# get variable information
nvar <-data$nvar
varnames <- names(data[['var']])

# -----------------------------------------------------------
# Export a selection of data as a spreadsheet

# Using the 'MAI090_TEMP_EXTREMES_SUMMARY_1944-2022.xlsx' spreadsheet, find the longest surface marine heatwave. 
# Info: event number 14, between 2016-01-16 00:00:00 and 2016-05-03 00:00:00

# get TIME and convert to R time
TIME <- data$dim$TIME[10]
TIME_R <- as.POSIXct((as.numeric(unlist(TIME)) - 7305)*86400, origin = "1970-01-01", tz = "UTC")

# surface
# create dataframe including TIME
data_surf <- data.frame(TIME = TIME_R)
# add all other variables at the surface only
for(i in 1:nvar) {
  data_surf[varnames[i]] = c(ncvar_get(data, varnames[i],start=c(1,1),count=c(1,data$dim$TIME$len)))
}

# 21 m
# create dataframe including TIME
data_21m <- data.frame(TIME = TIME_R)
# add all other variables at the surface only
for(i in 1:nvar) {
  data_21m[varnames[i]] = c(ncvar_get(data, varnames[i],start=c(2,1),count=c(1,data$dim$TIME$len)))
}


# Select temperature and the 90th percentiles during the long 2016 marine heatwave
c <- as.Date(TIME_R) >= as.Date('2016-01-16') & as.Date(TIME_R) <= as.Date('2016-05-03')
# time, temp, 90th percentiles
data_2016 <- data.frame(TIME = TIME_R[c],
                        TEMP_2m = data_surf$TEMP[c],
                        TEMP_21m = data_21m$TEMP[c],
                        PER90_2m = data_surf$TEMP_PER90[c],
                        PER90_21m = data_21m$TEMP_PER90[c])

# export data as csv
saving_path <- 'C:\\Users\\z3526971\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Scripts\\Tutorials\\R\\'
write.csv(data_2016, paste(saving_path,'MAI_TEMP_PER90_MHW14.csv'))

