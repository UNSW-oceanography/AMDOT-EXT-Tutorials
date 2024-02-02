# ##################################
# 
# ####################################################################
# 
# Script: get_DataProducts.py
# Description: Tutorial on how to download and load the AMDOT-EXT data products
# Created: 29 Nov 2022 by Michael Hemming (NSW-IMOS)
# 
# using R version 3.6.3 (2020-02-29), RStudio interface
# 
# ######################################################################################################################
# 
# ####### Any and all use of the AMDOT-EXT data products or accompanying event summary CSV files described here must include ####### 
#
# – a citation to the data paper: "Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters: Hemming et al., (2024). 
#    Earth System Science Data."
#
# – a reference to the data citation as written in the NetCDF file attributes and as follows: Hemming, MP. et al. (2023) "Australian Multi-decadal Ocean Time Series 
#    EXTreme (AMDOT-EXT) Data Products", Australian Ocean Data Network, https://doi.org/10.26198/wbc7-8h24."
#
# – the following acknowledgement statement: Data were sourced from Australia’s Integrated Marine Observing System280
# (IMOS) - IMOS is enabled by the National Collaborative Research Infrastructure Strategy (NCRIS).
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
# https://thredds.aodn.org.au/thredds/catalog/UNSW/NRS_extremes/catalog.html

# However, here we will load the file directly using OPeNDAP.

# For more information on the files and methodology, please see CITATION

## -----------------------------------------------------------
# load the data products
# We will use the Maria Island data product in this example

URL <- 'https://thredds.aodn.org.au/thredds/dodsC/UNSW/NRS_extremes/Temperature_DataProducts/MAI090/MAI090_TEMP_EXTREMES_1944-2022_v1.nc'

# load file
data <- nc_open(URL)

# get variable information
nvar <-data$nvar
varnames <- names(data[['var']])

# -----------------------------------------------------------
# Export a selection of data as a spreadsheet
# (Longest surface marine heatwave)

# get variables
temp_extreme_index <- ncvar_get(data, "TEMP_EXTREME_INDEX")
mhw_event_duration <- ncvar_get(data, "MHW_EVENT_DURATION")
# get TIME and convert to R time
TIME <- data$dim$TIME[10]
TIME_R <- as.POSIXct((as.numeric(unlist(TIME)) - 7305)*86400, origin = "1970-01-01", tz = "UTC")
# Find surface marine heatwaves
surf_mhws <- temp_extreme_index[1, ] == 12
# Extract surface durations
surf_duration <- mhw_event_duration[1, ]
# Find the longest duration
longest_duration <- max(surf_duration[surf_mhws], na.rm = TRUE)
# Identify the times with the longest duration
longest_selection <- surf_duration == longest_duration
longest_times <- TIME_R[longest_selection]

# CONTINUE HERE

#####################################################################################
## THIS SEGMENT IS FROM CHATGPT BUT DOESN"T WORK PROPERLY

# Select temperature and the 90th percentiles during the longest surface marine heatwave
c <- complete.cases(longest_times) & data$TIME >= min(longest_times[!is.na(longest_times)]) & data$TIME <= max(longest_times[!is.na(longest_times)])


# time
data_selection$TIME <- format(data$TIME[c], "%Y-%m-%d")

# temperature
data_selection$TEMP_2m <- data$TEMP[1, c]
data_selection$TEMP_21m <- data$TEMP[2, c]

# 90th percentiles
data_selection$PER90_2m <- data$TEMP_PER90[1, c]
data_selection$PER90_21m <- data$TEMP_PER90[2, c]

#####################################################################################



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