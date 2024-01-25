##################################

####################################################################

# Script: slice_DataProducts.py
# Description: Tutorial on how to load the AMDOT-EXT data products and slice data using event characteristics
# Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)

# using Python version 3.9, Spyder (managed using Anaconda)

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

# We will use the Port Hacking data product in this example
filename = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\Data\\Finalised_data\\' + 
            'V1\\FilesAODNupload\\ManuscriptVersion_2022\\' + 'PH100_TEMP_EXTREMES_1953-2022_v1.nc')
# filename = ('https://thredds.aodn.org.au/thredds/dodsC/UNSW/NRS_extremes/Temperature_DataProducts/' + 
#             'PH100/PH100_TEMP_EXTREMES_1953-2022_v1.nc')
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
DurMean = np.int32(data22mMHWStrong.MHW_EVENT_DURATION.mean())

print('PH100 22m: Strong MHWs last on average ' + str(DurMean) + ' days and have a mean intensity of ' + str(IntMean.values) +
      ' degrees celsius. The average max and cumulative intensity is ' + str(IntMeanMax.values) + ' degrees celsius' + 
      ' and ' + str(IntMeanCumulative.values) + ' degrees celsius days, respectively.')

# %% -----------------------------------------------------------
# save sliced dataset as NetCDF and CSV

# local saving path (uncomment and modify)
# saving_path = ['local_path_to_save_the_CSV']
saving_path = ('C:\\Users\\mphem\\OneDrive - UNSW\\Work\\Temperature_extremes\\Temperature_extremes\\' + 
                'Scripts\\Tutorials\\AMDOT-EXT-Tutorials\\Python\\')

# saving NetCDF file
data22mMHWStrong.to_netcdf(saving_path + 'PH100_strong_MHWs_22m.nc')

# export data as csv
data22mMHWStrong.to_pandas().to_csv(saving_path + 'PH100_strong_MHWs_22m.csv')

# there are other formats that can be selected
# e.g. 'to_latex', 'to_excel'






