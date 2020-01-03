% This method is static.
function gld_time_zone = GetGridlabdTimeZone(t)
% Converts the time zone of t from Matlab format to the one used by Gridlab
% Input: t is a datetime
% Output: time zone in Gridlabd format or empty if conversion failed


validateattributes(t,{'datetime'},{'scalar'},mfilename,'t',1);

time_zone = t.TimeZone;

gld_time_zone = [];

% If datetime does not have a specified timezone, leave empty. This
% will fall back to the time zone specified in the glm file.
if ~isempty(time_zone)
    expr = '\w+/(\w+)';
    [tokens,matches] = regexp(time_zone,expr,'tokens','match');

    % We expect a single token with the city name
    assert(numel(tokens) == 1 && numel(tokens{1}) == 1 , 'Unexpected number of tokens.');

    city_pre = tokens{1}{1};

    % Matlab timezones use underscores for cities, Gridlabd uses spaces
    city = strrep(city_pre,'_',' ');

    % gridlabd_time_zone_map can be created using aaCreateTimzeZoneMap
    file_path = mfilename('fullpath');
    folder_path = fileparts(file_path);

    tz_map_struct = load([folder_path,'/gridlabd_time_zone_map']);
    tz_map = tz_map_struct.tz_map;

    if tz_map.isKey(city)
        gld_time_zone_c = tz_map(city);
        gld_time_zone = gld_time_zone_c{1};
    else
        warning('GetGridlabdTimeZone:NoGridlabTimeZone','Could not find Gridlab time zone equivalent for %s. Falling back to time-zone specified in glm file.',time_zone)
    end
end
end