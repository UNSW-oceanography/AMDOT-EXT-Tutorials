##################################

####################################################################


# Script: slice_DataProducts.py
# Description: Tutorial on how to load the AMDOT-EXT data products
#              and slice data using event characteristics
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
import numpy as np

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

# We will use the Port Hacking data product in this example

# filename = 'http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html'
filename = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Data\\' + 
            'Finalised_data\\PH100_TEMP_EXTREMES_1953-2022_v1.nc')

data = xr.open_dataset(filename)

# %% -----------------------------------------------------------
# select data at 22m depth when there are strong MHWs

# data at 22 m
#----------------------------------
data22m = data.sel(DEPTH=22)

# MHWs
#----------------------------------
# flag_values:    [ 0  1  2 11 12]
# flag_meanings:  no_event cold_spike marine_cold_spell heat_spike marine_heatwave
data22mMHW = data22m.where(data22m.TEMP_EXTREME_INDEX==12,drop=True); # not needed, user could just use category if wished

# 'strong' events only
#----------------------------------
# flag_values:    [0 1 2 3 4]
# flag_meanings:  no_event moderate strong severe extreme
data22mMHWStrong = data22m.where(data22mMHW.MHW_EVENT_CAT==2,drop=True)

# %% -----------------------------------------------------------
# calculate statistics and display

IntMeanCumulative = np.round(data22mMHWStrong.MHW_EVENT_INTENSITY_CUMULATIVE.mean(),1)
IntMeanMax = np.round(data22mMHWStrong.MHW_EVENT_INTENSITY_MAX.mean(),1)
IntMean = np.round(data22mMHWStrong.MHW_EVENT_INTENSITY_MEAN.mean(),1)
DurMean = np.int32(data22mMHWStrong.MHW_EVENT_DURATION.mean()/np.timedelta64(1, 'D'))

print('PH100 22m: Strong MHWs last on average ' + str(DurMean) + ' days and have a mean intensity of ' + str(IntMean.values) +
      ' degrees celsius. The average max and cumulative intensity is ' + str(IntMeanMax.values) + ' degrees celsius' + 
      ' and ' + str(IntMeanCumulative.values) + ' degrees celsius days, respectively.')

# %% -----------------------------------------------------------
# save sliced dataset as NetCDF and CSV

saving_path = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\' + 
               'Temperature_extremes\\Scripts\\Tutorials\\Python\\')

# saving NetCDF file
data22mMHWStrong.to_netcdf(saving_path + 'PH100_strong_MHWs_22m.nc')

# export data as csv
data22mMHWStrong.to_pandas().to_csv(saving_path + 'PH100_strong_MHWs_22m.csv')

# there are other formats that can be selected
# e.g. 'to_latex', 'to_excel'






