function [U_array,T_array,p_pcc_array,q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array)
% |static| Solves the power flow equations approximately using a power flow surrogate
%
% Synopsis::
%
%   [U_array,T_array,p_pcc_array,q_pcc_array,opf_problem] = PowerFlowSurrogate_Bernstein2017_LP_3.SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array)
%
% Description:
%   Tells :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper<+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper>`
%   which power flow surrogate to use for approximately solving the power flow equations
%
% Arguments:
%   load_case (|uot.LoadCasePy|): Load case for which power flow will be solved
%   u_pcc_array (double): Array(n_phase,n_time_step) of voltage magnitudes at |pcc|
%   t_pcc_array (double): Array(n_phase,n_time_step) of voltage angles at |pcc|
%
% Returns:
%
%   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
%   - **T_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage angles
%   - **p_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with active power injection at the |pcc|
%   - **q_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with reactive power injection at the |pcc|
%   - **opf_problem** (|uot.OPFproblem|) - Power flow problem used to approximately solve power flow
%
% See Also:
%   :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper<+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper>`
%

% .. Line with 80 characters for reference #####################################



% |static|
pf_surrogate_spec = PowerFlowSurrogate_Bernstein2017_LP_3;
[U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper(pf_surrogate_spec,load_case,u_pcc_array,t_pcc_array);
end