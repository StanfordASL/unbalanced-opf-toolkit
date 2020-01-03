function [U_array,T_array] = ComputeVoltageEstimate(obj)
% |protected| Computes the estimate for complex voltages given by the power flow surrogate
%
% Synopsis::
%
%   [U_array,T_array] = pf_surrogate.ComputeVoltageEstimate()
%
% Returns:
%
%   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
%   - **T_array** (double) - empty array
%
% Note:
%  T_array is empty because this surrogate does not keep track of voltage angles.

network = obj.opf_problem.network;
U_array = uot.UnstackPhaseConsistent(value(obj.decision_variables.U_array_stack),network.bus_has_phase);

T_array = [];
end