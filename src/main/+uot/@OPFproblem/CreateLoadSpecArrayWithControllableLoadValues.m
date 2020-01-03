function load_spec_array = CreateLoadSpecArrayWithControllableLoadValues(obj)
% |private| Create an array of |uot.LoadPySpec| with the current value of the controllable loads
%
% Synopsis::
%
%   load_spec_array = obj.CreateLoadSpecArrayWithControllableLoadValues()
%
% Description:
%	This method first evaluates the current value of the controllable loads. Then,
%	these values are put into an array of |uot.LoadPySpec|. This is part of the process
%	to solve power flow with the current values of the controllable loads.
%
%
% Returns:
%
%   - **load_spec_array** (|uot.LoadPySpec|) - Array(n_controllable_load) with the current value of the controllable loads
%
%
% See Also:
%   :meth:`uot.OPFproblem.SolvePFwithControllableLoadValues<+uot.@OPFproblem.OPFproblem.SolvePFwithControllableLoadValues>`
%

% .. Line with 80 characters for reference #####################################

controllable_load_cell = obj.controllable_load_hashtable.values.';

n_controllable_load_cell = numel(controllable_load_cell);

load_spec_cell = cell(n_controllable_load_cell,1);

for i_controllable_load_cell = 1:n_controllable_load_cell
    load_spec_cell{i_controllable_load_cell} = controllable_load_cell{i_controllable_load_cell}.CreateLoadPySpecWithCurrentValue();
end

load_spec_array = vertcat(load_spec_cell{:});
end