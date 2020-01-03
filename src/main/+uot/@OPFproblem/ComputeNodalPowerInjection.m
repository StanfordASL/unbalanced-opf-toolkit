function [P_inj_array,Q_inj_array] = ComputeNodalPowerInjection(obj)
% |private| Compute power injection at the buses from controllable and uncontrollable loads
%
% Synopsis::
%
%   val = obj.ComputeNodalPowerInjection()
%
% Description:
%   This method sums the power injection from the controllable loads, if there are
%   any, with the power injection from the uncontrollable loads in the load case.
%
% Returns:
%
%   - **P_inj_array** (sdpvar) - Array(n_bus, n_phase, n_time_step) of active power injection
%   - **Q_inj_array** (sdpvar) - Array(n_bus, n_phase, n_time_step) of reactive power injection
%

% .. Line with 80 characters for reference #####################################

[P_inj_controllable_array,Q_inj_controllable_array] = ...
    obj.GetPowerInjectionFromControllableLoads();

% Add loads from load case
S_y_array = obj.load_case.S_y;

P_y_array = real(S_y_array);
Q_y_array = imag(S_y_array);

% Loads are negative power injections
P_inj_pq_pre_array = P_inj_controllable_array - P_y_array;
Q_inj_pq_pre_array = Q_inj_controllable_array - Q_y_array;

% We guarantee in uot.AbstractLoadCase.BuildPyLoadMatrix and
% uot.ControllableLoad.ValidateSpec that the reference bus has no loads.
% Hence, we can safely neglect it.
P_inj_pq_array = P_inj_pq_pre_array(2:end,:,:);
Q_inj_pq_array = Q_inj_pq_pre_array(2:end,:,:);

% Add substation load
[p_pcc_array,q_pcc_array] = obj.GetPowerInjectionFromPCCload();

P_inj_pcc_array = uot.PermuteDims1and3(p_pcc_array);
Q_inj_pcc_array = uot.PermuteDims1and3(q_pcc_array);

P_inj_array = [P_inj_pcc_array;P_inj_pq_array];
Q_inj_array = [Q_inj_pcc_array;Q_inj_pq_array];
end