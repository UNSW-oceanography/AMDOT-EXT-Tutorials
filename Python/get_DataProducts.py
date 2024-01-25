##################################

####################################################################

# Script: get_DataProducts.py
# Description: Tutorial on how to download and load the AMDOT-EXT data products
# Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)

# using Python version 3.12, Spyder (managed using Anaconda)
# See 'AMDOT-EXT_py312.yml.yml' for python environment details

######################################################################################################################

# % ####### Any and all use of the AMDOT-EXT data products or accompanying event summary CSV files described here must include ####### 
# %
# % – a citation to the data paper: "Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters: Hemming et al., (2024). 
# %    Earth System Science Data. https://doi.org/10.5194/essd-2023-252."
# %
# % – a reference to the data citation as written in the NetCDF file attributes and as follows: Hemming, MP. et al. (2023) "Australian Multi-decadal Ocean Time Series 
# %    EXTreme (AMDOT-EXT) Data Products", Australian Ocean Data Network, https://doi.org/10.26198/wbc7-8h24."
# %
# % – the following acknowledgement statement: Data were sourced from Australia’s Integrated Marine Observing System280
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
# 'conda install <package>' or 'pip install <package>'

# %% -----------------------------------------------------------
# Download the data products

# % The netCDF files are available for download here:
# % https://thredds.aodn.org.au/thredds/catalog/UNSW/NRS_extremes/catalog.html

# % However, in this tutorial we will load the file directly using OPeNDAP.

# %% -----------------------------------------------------------
# load the data products

# We will use the Maria Island data product in this example
filename = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Data\\Finalised_data\\' + 
            'V1\\FilesAODNupload\\ManuscriptVersion_2022\\' + 'MAI090_TEMP_EXTREMES_1944-2022_v1.nc')

filename = ('https://thredds.aodn.org.au/thredds/dodsC/UNSW/NRS_extremes/Temperature_DataProducts/' + 
            'MAI090/MAI090_TEMP_EXTREMES_1944-2022_v1.nc')
data = xr.open_dataset(filename)

# %% -----------------------------------------------------------
# % Export a selection of data as a spreadsheet
# % (Longest surface marine heatwave)

# get times of the longest surface marine heatwave 
SurfMHWs = data['TEMP_EXTREME_INDEX'][:,0].values == 12;
SurfDuration = data['MHW_EVENT_DURATION'][:,0].values; 
LongestDuration = np.nanmax(SurfDuration[SurfMHWs]);
LongestSelection = SurfDuration == LongestDuration;
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
saving_path = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\' + 
                'Scripts\\Tutorials\\AMDOT-EXT-Tutorials\\Python\\')

data2save.to_csv(saving_path + 'MAI_TEMP_PER90_LongestMHW.csv')



