function [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)
% Assign no load solution to OPF problem
%
% Synopsis::
%
%  [U_array,T_array,p_pcc_array,q_pcc_array] = opf_problem.AssignBaseCaseSolution()
%
% Description:
%	This methods assigns zero load to the controllable loads. It then requests
%	the power flow surrogate to assign the no load solution (i.e., only including
%	the uncontrollable loads. Finally, it sets the pcc load to the no load solution.
%
% Returns:
%
%	- **U_array** (double) - Voltage magnitude array of the no-load solution
%	- **T_array** (double) - Voltage angle array of the no-load solution
%	- **p_pcc_array** (double) - Real power of the swing load in the no-load solution
%	- **q_pcc_array** (double) - Reactive power of the swing load in the no-load solution
%
% Note:
%
%	This method is meant for debugging infeasible problems. Typically, the
%	no load solution should be feasible. After calling this method, we can use
%	|yalmip|'s :func:`check` function to find out what constraints are infeasible.

% .. Line with 80 characters for reference #####################################


obj.AssignControllableLoadsToNoLoad();

[U_array,T_array,p_pcc_array,q_pcc_array] = obj.pf_surrogate.AssignBaseCaseSolution();

assign(obj.pcc_load.p,p_pcc_array);
assign(obj.pcc_load.q,q_pcc_array);
end