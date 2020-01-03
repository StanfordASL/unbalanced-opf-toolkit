function controllable_load_constraint_array = GetControllableLoadConstraintArray(obj)
% |private| Collects constraints from controllable loads into an array
%
% Synopsis::
%
%   controllable_load_constraint_array = obj.GetControllableLoadConstraintArray()
%
% Description:
%   Goes through all controllable loads requesting their constraints. Then,
%   assembles all of them in an array.
%
% Returns:
%
%   - **controllable_load_constraint_array** (constraint) - Array of constraints from controllable loads
%
%
% See Also:
%   :func:`uot.ControllableLoad.GetConstraintArray<+uot.@ControllableLoad.ControllableLoad.GetConstraintArray>`
%

% .. Line with 80 characters for reference #####################################


controllable_load_cell = obj.controllable_load_hashtable.values.';

n_controllable_load_cell = numel(controllable_load_cell);

controllable_load_constraint_cell = cell(n_controllable_load_cell,1);

for i_controllable_load_cell = 1:n_controllable_load_cell
    controllable_load_constraint_cell{i_controllable_load_cell} = controllable_load_cell{i_controllable_load_cell}.GetConstraintArray();
end

controllable_load_constraint_array = vertcat(controllable_load_constraint_cell{:});
end