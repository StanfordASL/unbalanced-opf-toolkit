function AssertConstraintSatisfaction(obj)
% Verify that specified constraints are fulfilled
%
% Synopsis::
%
%	opf_problem.AssertConstraintSatisfaction()
%
% Description:
%	The specification of the OPF problem |uot.OPFspec| contains several constraints
%	which we want the solution to fulfill. This method verifies that the solution
%	does indeed fulfill these constraints.
%
% Note:
%
%	- This method requires solving the optimization problem first
%	- This method is meant to be used for debugging
%

% .. Line with 80 characters for reference #####################################


for controllable_load_c = obj.controllable_load_hashtable.values
	assert(numel(controllable_load_c) == 1)
    controllable_load = controllable_load_c{1};
    controllable_load.AssertConstraintSatisfaction();
end

obj.pcc_load.AssertConstraintSatisfaction();

obj.pf_surrogate.AssertConstraintSatisfaction();
end
