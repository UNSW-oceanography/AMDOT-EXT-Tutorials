function [data] = load_netCDF(filename,imos_time)
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
% filename     |     string input including path and netCDF filename (including extension)
% imos_time   |     0/1 => no/yes to convert netCDF IMOS convention time (days since 1950-01-01) to MATLAB datenum 
%
% Output:
%
% data      |     structure file containing variables included in netCDF, plus file attributes and information

%% get information
data.file_info = ncinfo(filename);

%% Obtain all variables in file

variables = data.file_info.Variables;

% Loop through each variable and read its data
for i = 1:length(variables)
    varName = variables(i).Name;
    data.(varName) = ncread(filename, varName);
    
    % Display variable name and size
    disp(['Variable: ', varName, ', Dimensions: ', num2str(size(varData))]);
end

%% convert from IMOS time to MATLAB datenum if required

if imos_time == 1
    data.TIME = datenum(1950,01,01) + data.TIME;
end

end
