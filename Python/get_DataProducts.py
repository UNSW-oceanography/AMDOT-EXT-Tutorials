##################################

####################################################################

# Script: get_DataProducts.py
# Description: Tutorial on how to load an AMDOT-EXT data product using
#              OPeNDAP, and export data as a CSV file
# Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)

# using Python version 3.12, Spyder (managed using Anaconda)
# See 'AMDOT-EXT_py312.yml.yml' for python environment details

######################################################################################################################

# % ####### Any and all use of the AMDOT-EXT data products or accompanying event summary CSV files described here must include ####### 
# %
# % – a citation to the data paper: " Hemming et al., (2024). Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters, 
# %    Earth System Science Data."
# %
# % – a reference to the data citation as written in the NetCDF file attributes
# %
# % – the following acknowledgement statement: Data were sourced from Australia’s Integrated Marine Observing System
# % (IMOS) - IMOS is enabled by the National Collaborative Research Infrastructure Strategy (NCRIS).
# %

######################################################################################################################

##################################

# %% -----------------------------------------------------------
# Importing packages

import xarray as xr
import pandas as pd
import numpy as np

# If you do not currently have these packages installed, please use either
# 'conda install package_name' or 'pip install package_name'

# %% -----------------------------------------------------------
# Download the data products

# % The netCDF files are available for download here:
# % https://thredds.aodn.org.au/thredds/catalog/UNSW/NRS_extremes/catalog.html

# % However, in this tutorial we will load the file directly using OPeNDAP.

# %% -----------------------------------------------------------
# load the data products

# We will use the Maria Island data product in this example

filename = ('https://thredds.aodn.org.au/thredds/dodsC/UNSW/NRS_extremes/Temperature_DataProducts/' + 
            'MAI090/MAI090_TEMP_EXTREMES_1944-2022_v1.nc')
data = xr.open_dataset(filename)

# %% -----------------------------------------------------------
# % Export a selection of data as a spreadsheet
# % (Longest surface marine heatwave)

# get times of the longest surface marine heatwave 
# select surface MHWs
SurfMHWs = data['TEMP_EXTREME_INDEX'][:,0].values == 12;
# select surface MHW duration
SurfDuration = data['MHW_EVENT_DURATION'][:,0].values; 
# determine longest surface MHW
LongestDuration = np.nanmax(SurfDuration[SurfMHWs]);
# get boolean to select longest surface MHW
LongestSelection = SurfDuration == LongestDuration;
# select times during the longest surface MHW
LongestTimes = data['TIME'][LongestSelection];

# Select temperature and the 90th percentiles during marine heatwave
data_selection = data.sel(TIME=slice(np.min(LongestTimes.values),np.max(LongestTimes.values)))

# Temperature
TEMP_selection = data_selection.TEMP.to_pandas()
# rename columns
TEMP_selection.rename(columns = {2.0:'TEMP 2m'}, inplace = True)
TEMP_selection.rename(columns = {21.0:'TEMP 21m'}, inplace = True)

# 90th percentiles
PER90_selection = data_selection.TEMP_PER90.to_pandas()
# rename columns
PER90_selection.rename(columns = {2.0:'PER90 2m'}, inplace = True)
PER90_selection.rename(columns = {21.0:'PER90 21m'}, inplace = True)

#  merge data frames for exporting as spreadsheet
data2save = pd.merge(TEMP_selection,PER90_selection,left_on='TIME',right_on='TIME')

# export data as csv
# local saving path (uncomment and modify)
# saving_path = ['local_path_to_save_the_CSV']

data2save.to_csv(saving_path + 'MAI_TEMP_PER90_LongestMHW.csv')

