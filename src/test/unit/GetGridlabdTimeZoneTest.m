function tests = GetGridlabdTimeZoneTest
% aaBoilerplateTest Verifies xx

% This enables us to run the test directly instead of only through runtests
call_stack = dbstack;

% Call stack has only one element if function was called directly
if ~any(contains({call_stack.name},'runtests'))
    this_file_name = mfilename();
    runtests(this_file_name)
end

tests = functiontests(localfunctions);
end

function setupOnce(test_case)
aaSetupPath
end

function TestGetGridlabdTimeZone(test_case)
time_zone_cell = {
    'America/Los_Angeles', 'US/CA/Los Angeles'
    'America/Montreal', 'CA/QC/Montreal';
    'Europe/Berlin', 'EU/DE/Berlin';
    'Europe/San_Marino','EU/SM/San Marino';
    'Australia/Melbourne', 'AU/NSW/Melbourne';
    'Australia/Broken_Hill','AU/NSW/Broken Hill';
    % Empty timezone should return empty
    '',[];
    };

n_timezone_cell = size(time_zone_cell,1);

for i_timezone_cell = 1:n_timezone_cell
    matlab_time_zone = time_zone_cell{i_timezone_cell,1};
    gld_time_zone_ref = time_zone_cell{i_timezone_cell,2};

    t = datetime('now','TimeZone',matlab_time_zone,'Format','d-MMM-y HH:mm:ss Z');
    gld_time_zone = uot.ModelImporter_Gridlabd.GetGridlabdTimeZone(t);

    diagnostic_string = sprintf('Error in timezone %s',matlab_time_zone);
    verifyEqual(test_case,gld_time_zone,gld_time_zone_ref,diagnostic_string);
end

time_zone_warining_cell = {
    % These are not implemented in Gridlab. Should return empty and throw a warning
    'America/Mexico_City', [];
    'America/Sao_Paulo',[];
    };

n_time_zone_warining_cell = size(time_zone_warining_cell,1);

for i_time_zone_warining_cell = 1:n_time_zone_warining_cell
    matlab_time_zone = time_zone_warining_cell{i_time_zone_warining_cell,1};

    t = datetime('now','TimeZone',matlab_time_zone,'Format','d-MMM-y HH:mm:ss Z');

    f_h = @() uot.ModelImporter_Gridlabd.GetGridlabdTimeZone(t);

    verifyWarning(test_case,f_h,'GetGridlabdTimeZone:NoGridlabTimeZone');
end

end