% ##################################
% 
% ####################################################################
% 
% Script: get_DataProducts.py
% Description: Tutorial on how to download and 
%                   load the AMDOT-EXT data products
% Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)
% 
% using Matlab version 9.8.0.1417392 (R2020a), 23.2.0.2409890 (R2023b) Update 3 
% 
% ######################################################################################################################
% 
% ####### Please cite the accompanying data set paper if you use the AMDOT-EXT data products #######
% 
% Hemming, M., Roughan, M., and Schaeffer, A.: Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters, 
% Earth Syst. Sci. Data Discuss. (2024)
% 
% ######################################################################################################################
% 
% ##################################

%% -----------------------------------------------------------
% Download the data products
 
% The netCDF files are available for download here:
% http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html

% However, here we will load the file directly using OPeNDAP.

% For more information on the files and methodology, please see CITATION

%% -----------------------------------------------------------
% load the data products
% We will use the Maria Island data product in this example

path = 'C:\Users\mphem\OneDrive - UNSW\Work\Temperature_extremes\Temperature_extremes\Scripts\Tutorials\MATLAB\';

% filename = 'http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html'
filename =['C:\Users\mphem\OneDrive - UNSW\Work\Temperature_extremes\Temperature_extremes\Data\', ...
                'Finalised_data\MAI090_TEMP_EXTREMES_1944-2022_v1.nc'];

cd(path)
            
% load file
data = load_netCDF(filename,1);

%% -----------------------------------------------------------
% Export a selection of data as a spreadsheet

% Using the 'MAI090_TEMP_EXTREMES_SUMMARY_1944-2022.xlsx' spreadsheet, find the longest surface marine heatwave. 
% Info: event number 14, between 2016-01-16 00:00:00 and 2016-05-03 00:00:00

% Select temperature and the 90th percentiles during the long 2016 marine heatwave
c = data.TIME >= datenum(2016,01,16) & data.TIME <= datenum(2016,05,03);

% time
data_2016.TIME = datestr(data.TIME(c),'yyyy-mm-dd');
% temperature
data_2016.TEMP_2m = data.TEMP(1,c)';
data_2016.TEMP_21m = data.TEMP(2,c)';
% 90th percentiles
data_2016.PER90_2m = data.TEMP_PER90(1,c)';
data_2016.PER90_21m = data.TEMP_PER90(2,c)';

% export data as csv
saving_path = ['C:\Users\mphem\OneDrive - UNSW\Work\Temperature_extremes\',... 
               'Temperature_extremes\Scripts\Tutorials\MATLAB\']
writetable(struct2table(data_2016), [saving_path,'MAI_TEMP_PER90_MHW14.csv'])
disp(['.csv saved in: ',saving_path])

clear c







