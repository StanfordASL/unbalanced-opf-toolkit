function ValidateTimeStampArray(obj,time_stamp_array)
% Verifies that time_stamp_array is consistent with the spec.
% Input is an array of POSIX time stamps.
%	- Number of elements matches n_time_step
%	- All time stamps are equally spaced by time_step_s
%	- First time stamp matches start_date_time

n_time_stamp = numel(time_stamp_array);
assert(n_time_stamp == obj.spec.n_time_step,'Unexpected number of time stamps.')

time_delta_s = diff(time_stamp_array);
assert(all(time_delta_s == obj.spec.time_step_s),'Time stamp difference does not match spec.time_step_s')

if time_stamp_array(1) ~= posixtime(obj.spec.start_date_time)
    diagnostic_string = ['Initial time stamp does not match spec.start_date_time. ', ...
       'The cause might be that Gridlabd and Matlab are using different time zones.'];

   warning(diagnostic_string)
end
end