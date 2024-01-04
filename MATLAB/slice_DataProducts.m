%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script: slice_DataProducts.py
% Description: Tutorial on how to load the AMDOT-EXT data products
%                   and slice data using event characteristics
% Created: 28 Nov 2022 by Michael Hemming (NSW-IMOS)

% using Matlab version 9.8.0.1417392 (R2020a) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Please cite the accompanying data set paper if you use the AMDOT-EXT data products %%%%%%%

% ADD CITATION HERE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% -----------------------------------------------------------
% Download the data products

% The netCDF files are available for download here:
% http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html
%
% However, here we will load the file directly using OPeNDAP.
%
% For more information on the files and methodology, please see CITATION

%% -----------------------------------------------------------
% load the data products

% We will use the Port Hacking data product in this example

path = 'C:\Users\mphem\OneDrive - UNSW\Work\Temperature_extremes\Temperature_extremes\Scripts\Tutorials\MATLAB\';

% filename = 'http://thredds.aodn.org.au/thredds/catalog/UNSW/UPDATE_HERE_WHEN_READY/catalog.html'
filename =['C:\Users\mphem\OneDrive - UNSW\Work\Temperature_extremes\Temperature_extremes\Data\', ...
                'Finalised_data\PH100_TEMP_EXTREMES_1953-2022_v1.nc'];

cd(path)
            
% load file
data = load_netCDF(filename,1);

clear filename

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
% convert data to cell for looping
data_cell =  struct2cell(data);
% select data during strong MHWs at 22m depth
for n_var = 4:numel(vars)
    data_loop = data_cell{n_var};
    % select 22m depth
    data_loop = data_loop(2,:);
    % during strong MHWs
    data_loop = data_loop(data.MHW_EVENT_CAT(2,:) == 2);
    % save in new cell
    data22mMHWStrong{n_var} = data_loop';
end
% convert from cell back to structure
data22mMHWStrong = cell2struct(data22mMHWStrong,vars,2);
% add time
data22mMHWStrong.TIME = datestr(data.TIME(data.MHW_EVENT_CAT(2,:) == 2),'yyyy-mm-dd');
% remove unnecessary vars
data22mMHWStrong = rmfield(data22mMHWStrong,'file_info');
data22mMHWStrong = rmfield(data22mMHWStrong,'DEPTH');

clear data_cell data_loop n_var vars

%% -----------------------------------------------------------
% calculate statistics and display

IntMeanCumulative = round(nanmean(data22mMHWStrong.MHW_EVENT_INTENSITY_CUMULATIVE),1)
IntMeanMax = round(nanmean(data22mMHWStrong.MHW_EVENT_INTENSITY_MAX),1)
IntMean = round(nanmean(data22mMHWStrong.MHW_EVENT_INTENSITY_MEAN),1)
DurMean = round(nanmean(data22mMHWStrong.MHW_EVENT_DURATION))

disp(['PH100 22m: Strong MHWs last on average ',num2str(DurMean),' days and have a mean intensity of ',num2str(IntMean), ...
      ' degrees celsius.'])
disp(['The average max and cumulative intensity is ', num2str(IntMeanMax),' degrees celsius', ...
        ' and ',num2str(IntMeanCumulative),' degrees celsius days, respectively.']);

%% -----------------------------------------------------------
% save sliced dataset as NetCDF and CSV

saving_path = ['C:\Users\mphem\OneDrive - UNSW\Work\Temperature_extremes\',... 
               'Temperature_extremes\Scripts\Tutorials\MATLAB\'];

% saving MAT file
save([saving_path,'PH100_strong_MHWs_22m.mat'],'data22mMHWStrong');
% export data as csv
writetable(struct2table(data22mMHWStrong), [saving_path,'PH100_strong_MHWs_22m.csv'])
disp(['.csv saved in: ',saving_path])







