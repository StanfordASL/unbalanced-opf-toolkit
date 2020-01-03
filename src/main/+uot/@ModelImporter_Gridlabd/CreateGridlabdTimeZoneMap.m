% This method is static.
function CreateGridlabdTimeZoneMap()
% Creates a map from MATLAB's time zone format to the one used by Gridlabd and saves it

% This needs to be adapted to the location of Gridlabd code
path_to_gld_tzinfo = '~/Repos/gridlabd/gldcore/tzinfo.txt';

text = fileread(path_to_gld_tzinfo);

block_cell = strsplit(text,'\n');

expr = '[A-Z]{2}/[A-Z]+/(.+)';

[tokens,matches] = regexp(block_cell,expr,'tokens','match');

has_match = cellfun(@(x) ~isempty(x),matches);

time_zone_cell = matches(has_match);

% tokens has multiple layers of cells. Here we convert it into a cell array of char
city_cell_pre_1 = tokens(has_match);
city_cell_pre_2 = [city_cell_pre_1{:}];
city_cell = [city_cell_pre_2{:}];

% Create a map from city to time zone
tz_map = containers.Map(city_cell,time_zone_cell);

% Save in the folder where this function's code is
file_path = mfilename('fullpath');
folder_path = fileparts(file_path);

save([folder_path,'/gridlabd_time_zone_map'],'tz_map')
end