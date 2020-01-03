function constraint_array = GetConstraintArray(obj)
% Assembles constraints for the OPF problem into an array
%
% Synopsis::
%
%   constraint_array = opf_problem.GetConstraintArray()
%
% Description:
%	Requests constraints from controllable loads, |pcc| load and the used power
%	flow surrogate. Then, puts them all into an array.
%
%	Implements :func:`uot.ConstraintProvider.GetConstraintArray<+uot.@ConstraintProvider.ConstraintProvider.GetConstraintArray>`
%
% Returns:
%
%   - **constraint_array** (constraint) - Array of constraints

% .. Line with 80 characters for reference #####################################

% Typically, we call GetConstraintArray before solving an optimization problem.
% Hence, clear U_array_cache and T_array_cache
obj.U_array_cache = [];
obj.T_array_cache = [];

controllable_load_constraint_array = obj.GetControllableLoadConstraintArray();

pcc_load_constraint_array = obj.pcc_load.GetConstraintArray();

pf_surrogate_constraint_array = obj.pf_surrogate.GetConstraintArray();

constraint_array = [
    controllable_load_constraint_array;
    pcc_load_constraint_array;
    pf_surrogate_constraint_array;
];
end