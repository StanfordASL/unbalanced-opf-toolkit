function decision_variables = DefineDecisionVariables(opf_problem)
% |static|, |private| Defines the decision variables used by this power flow surrogate
%
% Synopsis::
%
%   decision_variables = PowerFlowSurrogate_Bernstein2017_LP_3.DefineDecisionVariables(opf_problem)
%
% Description:
%   Create the sdpvars that will be used as decision variables. Namely,
%   a :term:`phase-consistent stack` of voltage magnitudes
%
% Arguments:
%   opf_problem (|uot.OPFproblem|): OPF problem where the power flow surrogate will be used
%
% Returns:
%
%   - **decision_variables** (struct) - Struct with field U_array_stack which
%
% Note:
%  The method is static so that it can be safely called from the constructor

network = opf_problem.network;
n_time_step = opf_problem.n_time_step;

n_bus_has_phase = network.n_bus_has_phase;

decision_variables.U_array_stack = sdpvar(n_bus_has_phase,n_time_step,'full');
end