function load_case = times(obj,vec)
% Scales the loads by multiplying them with a vector vec.
% If n_time_spec == 1 and vec has more than 1 elements, the new
% load case will have n_time_spec = numel(vec)
% If n_time_spec ~= 1, then vec must have either 1 or n_time_spec elements

validateattributes(vec,{'double'},{'vector'},mfilename,'vec',2);

n_time_step = obj.spec.n_time_step;
n_vec = numel(vec);

if n_time_step ~= 1
    assert(n_vec == n_time_step || n_vec == 1,'Since n_time_step ~= 1, vec must have either one or n_time_step elements.')
end

% Recall that specs are value classes. Hence, spec_new is a copy and not
% our own.
spec_new = obj.spec;

n_load_spec_array = numel(spec_new.load_spec_array);

for i = 1:n_load_spec_array
    spec_new.load_spec_array(i) = spec_new.load_spec_array(i).*vec;
end

if n_time_step == 1
    % If n_time_step is 1, n_vec specifies the new number of time steps
    spec_new.n_time_step = n_vec;
end

load_case = spec_new.Create(obj.network);
end