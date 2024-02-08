% ##################################
% 
% ####################################################################
% 
% Script: get_DataProducts.m
% Description: Tutorial on how to load an AMDOT-EXT data product using
%                     OPeNDAP, and export data as a CSV file
% Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)
% 
% using Matlab version 9.8.0.1417392 (R2020a), 23.2.0.2409890 (R2023b) Update 3 
% 
% ######################################################################################################################
% 
% ####### Any and all use of the AMDOT-EXT data products or accompanying event summary CSV files described here must include ####### 
%
% – a citation to the data paper: "Hemming et al., (2024). Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters, Earth System Science Data."
%
% – a reference to the data citation as written in the NetCDF file attributes
%
% – the following acknowledgement statement: Data were sourced from Australia’s Integrated Marine Observing System
% (IMOS) - IMOS is enabled by the National Collaborative Research Infrastructure Strategy (NCRIS).
%
% ######################################################################################################################
% 
% ##################################

%% -----------------------------------------------------------
% Download the data products
 
% The netCDF files are available for download here:
% https://thredds.aodn.org.au/thredds/catalog/UNSW/NRS_extremes/catalog.html

% However, in this tutorial we will load the file directly using OPeNDAP.

%% -----------------------------------------------------------
% load the data products
% We will use the Maria Island data product in this example
url = 'https://thredds.aodn.org.au/thredds/dodsC/UNSW/NRS_extremes/Temperature_DataProducts/MAI090/MAI090_TEMP_EXTREMES_1944-2022_v1.nc';
data = load_netCDF(url,1)

%% -----------------------------------------------------------
% Export a selection of data as a spreadsheet
% (Longest surface marine heatwave)

% get times of the longest surface marine heatwave 
% select surface MHWs
SurfMHWs = data.TEMP_EXTREME_INDEX(1,:) == 12;
% select surface MHW duration
SurfDuration = data.MHW_EVENT_DURATION(1,:); 
% determine longest surface MHW
LongestDuration = nanmax(SurfDuration(SurfMHWs));
% get logical to select longest surface MHW
LongestSelection = SurfDuration == LongestDuration;
% select times during the longest surface MHW
LongestTimes = data.TIME(LongestSelection);

% Select temperature and the 90th percentiles during the longest surface marine heatwave
% this logical is used to select the same timestamps at both 2m and 21m depth
c = data.TIME >= min(LongestTimes) & data.TIME <= max(LongestTimes);
% data selection
% time
data_selection.TIME = datestr(data.TIME(c),'yyyy-mm-dd');
% temperature
data_selection.TEMP_2m = data.TEMP(1,c)';
data_selection.TEMP_21m = data.TEMP(2,c)';
% 90th percentiles
data_selection.PER90_2m = data.TEMP_PER90(1,c)';
data_selection.PER90_21m = data.TEMP_PER90(2,c)';

% export data as csv
% local saving path (uncomment and modify)
% saving_path = ['local_path_to_save_the_CSV']
writetable(struct2table(data_selection), [saving_path,'MAI_TEMP_PER90_LongestMHW.csv'])
disp(['.csv saved in: ',saving_path])

clear c







