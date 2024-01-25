function [data] = load_netCDF(opendapURL,imos_time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load_netCDF.m

% Function created 18/06/2021 by Michael Hemming, NSW-IMOS Sydney
% using MATLAB version 9.8.0.1323502 (R2020a)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Input: 
%
% opendapURL     |     string input including opendap URL
% imos_time   |     0/1 => no/yes to convert netCDF IMOS convention time (days since 1950-01-01) to MATLAB datenum 
%
% Output:
%
% data      |     structure file containing variables included in netCDF, plus file attributes and information

%% Open the NetCDF file
ncid = netcdf.open(opendapURL, 'NOWRITE');

%% Get variable information
info = ncinfo(opendapURL);
variables = info.Variables;

%% Create a structure to store variable data and attributes
data = struct();
% Loop through each variable
for i = 1:length(variables)
    varName = variables(i).Name;
    % Read variable data
    data.(varName) = netcdf.getVar(ncid, netcdf.inqVarID(ncid, varName));
    % Display variable name and size
    disp(['Variable: ', varName, ', Dimensions: ', num2str(variables(i).Size)]);
end

%% store NetCDF file information
data.file_info = info;

%% Close the NetCDF file
netcdf.close(ncid);

%% convert from IMOS time to MATLAB datenum if required

if imos_time == 1
    data.TIME = datenum(1950,01,01) + data.TIME;
end

end
