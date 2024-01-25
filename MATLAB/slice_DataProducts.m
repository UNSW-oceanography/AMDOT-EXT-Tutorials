%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script: slice_DataProducts.py
% Description: Tutorial on how to load the AMDOT-EXT data products and slice data using event characteristics
% Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)

% using Matlab version 9.8.0.1417392 (R2020a), 23.2.0.2409890 (R2023b) Update 3 

% ######################################################################################################################
% 
% ####### Any and all use of the AMDOT-EXT data products or accompanying event summary CSV files described here must include ####### 
%
% – a citation to the data paper: "Exploring Multi-decadal Time Series of Temperature Extremes in Australian Coastal Waters: Hemming et al., (2024). 
%    Earth System Science Data. https://doi.org/10.5194/essd-2023-252."
%
% – a reference to the data citation as written in the NetCDF file attributes and as follows: Hemming, MP. et al. (2023) "Australian Multi-decadal Ocean Time Series 
%    EXTreme (AMDOT-EXT) Data Products", Australian Ocean Data Network, https://doi.org/10.26198/wbc7-8h24."
%
% – the following acknowledgement statement: Data were sourced from Australia’s Integrated Marine Observing System280
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
% We will use the Port Hacking data product in this example
url = 'https://thredds.aodn.org.au/thredds/dodsC/UNSW/NRS_extremes/Temperature_DataProducts/PH100/PH100_TEMP_EXTREMES_1953-2022_v1.nc';
data = load_netCDF(url,1)

%% -----------------------------------------------------------
% select data at 22m depth when there are strong MHWs

% MHWs
%----------------------------------
% flag_values:    [ 0  1  2 11 12]
% flag_meanings:  no_event cold_spike marine_cold_spell heat_spike marine_heatwave

% 'strong' events only
%----------------------------------
% flag_values:    [0 1 2 3 4]
% flag_meanings:  no_event moderate strong severe extreme

% get variable names in data structure
vars = fieldnames(data);
% select data during strong MHWs at 22m depth
for n_var = 1:numel(vars)
    if isempty(strmatch('file_info',vars{n_var})) & isempty(strmatch('TIME',vars{n_var})) & isempty(strmatch('DEPTH',vars{n_var}))
        data_loop = data.(vars{n_var});
        % select 22m depth
        data_loop = data_loop(2,:);
        % during strong MHWs
        data_loop = data_loop(data.MHW_EVENT_CAT(2,:) == 2);
        % save in new cell
        data22mMHWStrong.(vars{n_var}) = data_loop';
    end
end

% add time (Will be the last column in the CSV file)
data22mMHWStrong.TIME = datestr(data.TIME(data.MHW_EVENT_CAT(2,:) == 2),'yyyy-mm-dd');

clear data_cell data_loop n_var vars

%% -----------------------------------------------------------
% calculate statistics and display

IntMeanCumulative = round(nanmean(data22mMHWStrong.MHW_EVENT_INTENSITY_CUMULATIVE),1);
IntMeanMax = round(nanmean(data22mMHWStrong.MHW_EVENT_INTENSITY_MAX),1);
IntMean = round(nanmean(data22mMHWStrong.MHW_EVENT_INTENSITY_MEAN),1);
DurMean = round(nanmean(data22mMHWStrong.MHW_EVENT_DURATION));

disp(['PH100 22m: Strong MHWs last on average ',num2str(DurMean),' days and have a mean intensity of ',num2str(IntMean), ...
      ' degrees celsius.'])
disp(['The average max and cumulative intensity is ', num2str(IntMeanMax),' degrees celsius', ...
        ' and ',num2str(IntMeanCumulative),' degrees celsius days, respectively.']);

%% -----------------------------------------------------------
% save sliced dataset as NetCDF and CSV

% local saving path (uncomment and modify)
% saving_path = ['local_path_to_save_the_CSV']
% saving MAT file
save([saving_path,'PH100_strong_MHWs_22m.mat'],'data22mMHWStrong');
% export data as csv
writetable(struct2table(data22mMHWStrong), [saving_path,'PH100_strong_MHWs_22m.csv'])
disp(['.csv saved in: ',saving_path])







