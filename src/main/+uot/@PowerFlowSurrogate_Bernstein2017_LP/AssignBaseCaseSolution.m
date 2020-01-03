function [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)
% |protected| Assigns the :term:`base case` solution to the decision variables in the surrogate. Returns approximate power flow solution that is consistent with these values.
%
% Synopsis::
%
%   [U_array,T_array,p_pcc_array,q_pcc_array] = pf_surrogate.AssignBaseCaseSolution()
%
% Returns:
%
%   - **U_array** (double) - Phase consistent array (n_bus,n_phase,n_timestep) with voltage magnitudes
%   - **T_array** (double) - Empty array
%   - **p_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with active power injection at the |pcc|
%   - **q_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with reactive power injection at the |pcc|
%
% Note:
%  T_array is empty because this surrogate does not keep track of voltage angles.

% .. Line with 80 characters for reference #####################################

% This method assigns the base case solution (i.e., where all controllable
% loads are zero) to the decision variables in the surrogate.

u_pcc_array = obj.opf_problem.u_pcc_array;
t_pcc_array = obj.opf_problem.t_pcc_array;

% SolveApproxPowerFlowAlt operates in the same way as our optimization.
% Hence, since we are not considering controllable loads, the results from
% using it on load_case tell us the values that our decision variables
% should take in the base case solution.
load_case = obj.opf_problem.load_case;

% There are two important things to keep in mind:
% 1) In GetConstraintArray, we set decision_variables.U_array_stack equal to
% U_array_eq9. Whereas U_array in SolveApproxPowerFlowAlt comes from eq. 5a.
% The reason for this is that the constraint on minimal voltage magnitude is convex
% when using the formulation in eq. 9 but non convex when using the one in eq. 5a.
% We just need to be consistent.
%
% 2) we are not keeping track of phase. Hence, we ignore T_array
T_array = [];

[U_ast,T_ast] = obj.GetLinearizationVoltage();
[~,~, p_pcc_array, q_pcc_array,extra_data] = PowerFlowSurrogate_Bernstein2017_LP.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,U_ast,T_ast);

U_array = extra_data.U_array_eq9;

network = load_case.network;
U_array_stack = uot.StackPhaseConsistent(U_array,network.bus_has_phase);

% We use YALMIP's assign method to give the decision variables its values
assign(obj.decision_variables.U_array_stack,U_array_stack);
end