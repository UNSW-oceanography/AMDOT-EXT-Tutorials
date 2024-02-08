# AMDOT-EXT Data Product Code Tutorials

#### Code demonstrating how to load the Australian Multi-decadal Ocean Time series EXTreme (AMDOT-EXT) data products, use the NetCDF variables, and export the data as CSV files.

This repository contains python, MATLAB and R code as referenced in the following publication: 

_Hemming, Michael P., et al. "Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters." Earth System Science Data (2024)_

Code provided here was developed by Michael Hemming as part of a project funded by the University of New South Wales (UNSW). Code is provided "as is" without any warranty as to fitness for a particular purpose under a Creative Commons 4.0 license (http://creativecommons.org/licenses/by/4.0/)

[![CC BY 4.0][cc-by-shield]][cc-by]
=======

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by][![CC BY 4.0][cc-by-shield]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg

# Tutorials

### get_DataProducts (MATLAB, Python, R)

This script demonstrates how to:

* Load in the Maria Island 90m AMDOT-EXT data product directly from the AODN thredds server using OPenDAP
* Extract variables and convert time (MATLAB / R)
* Select data during the longest surface marine heatwave and export as a CSV file

### slice_DataProducts (MATLAB, Python, R)

This script demonstrates how to:

* Load in the Port Hacking 100m AMDOT-EXT data product directly from the AODN thredds server using OPenDAP
* Extract variables at a depth of 22m when there are strong marine heatwaves only, and convert time (MATLAB / R)
* Calculate average cumulative, max, and mean intensity during strong marine heatwaves, as well as mean duration (and print/display this information)
* save the sliced data in various formats (CSV, mat - MATLAB, NetCDF - Python, rdata - R)

### Notes
If using R/Python, you will need to install the required package/s. If using Python and are getting errors when running the code it could be that you are using different package versions. Please check the environment file ('AMDOT-EXT_py312.yml') for a list of package versions used for writing the tutorials. 

If you wish to save the data files, you will need to modify 'saving_path' to include your chosen local directory.

The MATLAB scripts require the 'load_netCDF.m' function to load in the file from AODN thredds via OPeNDAP.

<br><br>
