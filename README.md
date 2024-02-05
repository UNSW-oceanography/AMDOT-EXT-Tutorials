# AMDOT-EXT-Tutorials
### Code demonstrating how to download and load the Australian Multi-decadal Ocean Time series EXTreme (AMDOT-EXT) data products, use the NetCDF variables, produce plots, and export the data as CSV files.

This repository contains python, MATLAB and R code as referenced in the following publication: 

_Hemming, Michael P., et al. "Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters." Ocean Science (2024): {{page range}}. [https://doi.org/10.5194/egusphere-2022-1336]([https://doi.org/10.5194/essd-2023-252](https://doi.org/10.5194/egusphere-2022-1336))_

[![CC BY 4.0][cc-by-shield]][cc-by]
=======
If you use this code please cite as written below: 

Michael Hemming. (2023). UNSW-oceanography/AMDOT-EXT-Tutorials: v1.0.0.0 (v1.0.0.0). Zenodo. [![DOI](https://zenodo.org/badge/638034418.svg)](https://zenodo.org/badge/latestdoi/638034418)
{{Need to update this}}

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg

## Tutorials

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
