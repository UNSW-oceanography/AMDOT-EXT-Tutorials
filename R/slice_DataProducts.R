# ##################################
# 
# ####################################################################
# 
# Script: slice_DataProducts.py
# Description: Tutorial on how to load the AMDOT-EXT data products
#              and slice data using event characteristics
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

# We will use the Port Hacking data product in this example

path <- 'C:\\Users\\z3526971\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Scripts\\Tutorials\\R\\';

# filename = 'http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html'
filename ='C:\\Users\\z3526971\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Data\\Finalised_data\\PH100_TEMP_EXTREMES_1953-2022_v1.nc'

setwd(path)

# load file
data <- nc_open(filename)

# get variable information
nvar <-data$nvar
varnames <- names(data[['var']])

# -----------------------------------------------------------
# select data at 22m depth when there are strong MHWs

# get TIME and convert to R time
TIME <- data$dim$TIME[10]
TIME_R <- as.POSIXct((as.numeric(unlist(TIME)) - 7305)*86400, origin = "1970-01-01", tz = "UTC")

# 22 m
# create dataframe including TIME
data_22m <- data.frame(TIME = TIME_R)
# add all other variables at the surface only
for(i in 1:nvar) {
  data_22m[varnames[i]] = c(ncvar_get(data, varnames[i],start=c(2,1),count=c(1,data$dim$TIME$len)))
}


# MHWs
#----------------------------------
# flag_values:    [ 0  1  2 11 12]
# flag_meanings:  no_event cold_spike marine_cold_spell heat_spike marine_heatwave

# 'strong' events only
#----------------------------------
# flag_values:    [0 1 2 3 4]
# flag_meanings:  no_event moderate strong severe extreme


# during strong MHWs
c <- data_22m$MHW_EVENT_CAT == 2
# select data during strong MHWs only
# create dataframe 
data_22mMHWStrong <- data.frame(TIME = TIME_R[c])
# add other variables
for(i in 1:nvar) {
  d = unlist(data_22m[varnames[i]])
  data_22mMHWStrong[varnames[i]] = c(d[c])
}


# %% -----------------------------------------------------------
# calculate statistics and display

IntMeanCumulative = round(mean(data_22mMHWStrong$MHW_EVENT_INTENSITY_CUMULATIVE),1)
IntMeanMax = round(mean(data_22mMHWStrong$MHW_EVENT_INTENSITY_MAX),1)
IntMean = round(mean(data_22mMHWStrong$MHW_EVENT_INTENSITY_MEAN),1)
DurMean = round(mean(data_22mMHWStrong$MHW_EVENT_DURATION),1)

text1 <- paste('PH100 22m: Strong MHWs last on average ',as.character(DurMean),' days and have a mean intensity of ',
             as.character(IntMean),' degrees celsius.')
text2 <- paste('The average max and cumulative intensity is ', as.character(IntMeanMax),' degrees celsius',
               ' and ',as.character(IntMeanCumulative),' degrees celsius days, respectively.')

print(text1)
print(text2)


# %% -----------------------------------------------------------
# save sliced dataset as NetCDF and CSV

saving_path = ('C:\\Users\\z3526971\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Scripts\\Tutorials\\R\\')

# saving rdata file
save(data_22mMHWStrong, file = paste(saving_path,'PH100_strong_MHWs_22m.rdata'))
# export data as csv
write.csv(data_22mMHWStrong, paste(saving_path,'PH100_strong_MHWs_22m.csv'))

