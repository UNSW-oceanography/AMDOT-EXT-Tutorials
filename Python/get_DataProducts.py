##################################

####################################################################


# Script: get_DataProducts.py
# Description: Tutorial on how to download and 
#              load the AMDOT-EXT data products
# Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)

# using Python version 3.9, Spyder (managed using Anaconda)

######################################################################################################################

####### Please cite the accompanying data set paper if you use the AMDOT-EXT data products #######

# ADD CITATION HERE

######################################################################################################################

##################################

# %% -----------------------------------------------------------
# Importing packages

import xarray as xr
import pandas as pd

# If you do not currently have xarray installed, please use either
# 'conda install xarray' or 'pip install xarray'

# %% -----------------------------------------------------------
# Download the data products

# The netCDF files are available for download here:
# http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html
#
# However, here we will load the file directly using OPeNDAP.
#
# For more information on the files and methodology, please see CITATION

# %% -----------------------------------------------------------
# load the data products

# We will use the Maria Island data product in this example

# filename = 'http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html'
filename = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Data\\' + 
            'Finalised_data\\MAI090_TEMP_EXTREMES_1944-2022_v1.nc')

data = xr.open_dataset(filename)

# %% -----------------------------------------------------------
# Export a selection of data as a spreadsheet

# Using the 'MAI090_TEMP_EXTREMES_SUMMARY_1944-2022.xlsx' spreadsheet, find the longest surface marine heatwave. 
# Info: event number 14, between 2016-01-16 00:00:00 and 2016-05-03 00:00:00

# Select temperature and the 90th percentiles during the long 2016 marine heatwave
data_2016 = data.sel(TIME=slice('2016-01-16 00:00:00','2016-05-03 00:00:00'))

# Temperature
TEMP_2016 = data_2016.TEMP.to_pandas()
# rename columns
TEMP_2016.rename(columns = {2.0:'TEMP 2m'}, inplace = True)
TEMP_2016.rename(columns = {21.0:'TEMP 21m'}, inplace = True)

# 90th percentiles
PER90_2016 = data_2016.TEMP_PER90.to_pandas()
# rename columns
PER90_2016.rename(columns = {2.0:'PER90 2m'}, inplace = True)
PER90_2016.rename(columns = {21.0:'PER90 21m'}, inplace = True)

#  merge data frames for exporting as spreadsheet
data2save = pd.merge(TEMP_2016,PER90_2016,left_on='TIME',right_on='TIME')

# export data as csv
saving_path = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\' + 
               'Temperature_extremes\\Scripts\\Tutorials\\Python\\')
data2save.to_csv(saving_path + 'MAI_TEMP_PER90_MHW14.csv')

# there are other formats that can be selected
# e.g. 'to_latex', 'to_excel'






