function [U_array,T_array,p_pcc_array,q_pcc_array,extra_data] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
% |static| Approximately solve power flow
%
% Synopsis::
%
%   [U_array,T_array,p_pcc_array,q_pcc_array,extra_data] = uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
%
% Description:
%   It is very common that power flow surrogates offer a way of approximately solving power flow.
%   This is typically an algebraic approach that does not rely on solving an optimization
%   problem as done in :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlow<+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlow>`
%   This method can be overriden for this purpose.
%
% Arguments:
%   load_case (|uot.LoadCasePy|): Load case for which power flow will be approximately solved
%   u_pcc_array (double): Array(n_phase,n_time_step) of voltage magnitudes at |pcc|
%   t_pcc_array (double): Array(n_phase,n_time_step) of voltage angles at |pcc|
%   varargin (-): Additional arguments (implementation dependent)
%
% Returns:
%
%   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
%   - **T_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage angles
%   - **p_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with active power injection at the |pcc|
%   - **q_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with reactive power injection at the |pcc|
%   - **extra_data** (struct) - Struct with extra data (implementation dependent)
%
% See Also:
%   :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper<+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper>`
%

    error('Class did not override SolveApproxPowerFlowAlt.')
end