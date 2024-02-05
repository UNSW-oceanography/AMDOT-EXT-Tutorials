# ##################################
# 
# ####################################################################
# 
# Script: get_DataProducts.R
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
# – the following acknowledgement statement: Data were sourced from Australia’s Integrated Marine Observing System
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
temp <- ncvar_get(data, "TEMP")
temp_90 <- ncvar_get(data, "TEMP_PER90")
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

# select data
longest_times <- TIME_R[which(longest_selection)]
longest_temp2m <- temp[1, which(longest_selection)]
longest_temp21m <- temp[2, which(longest_selection)]
longest_temp_90_2m <- temp_90[1, which(longest_selection)]
longest_temp_90_21m <- temp_90[2, which(longest_selection)]

# create dataframe
data_longest <- data.frame(TIME = longest_times,
                           TEMP_2m = longest_temp2m,
                           TEMP_21m = longest_temp21m,
                           PER90_2m = longest_temp_90_2m,
                           PER90_21m = longest_temp_90_21m)

# export data as csv

# modify and uncomment to save CSV
# saving_path <- 'local\\path\\to\\save\\the\\CSV\\'
# write.csv(data_longest, paste(saving_path,'MAI_TEMP_PER90_LongestMHW.csv'))