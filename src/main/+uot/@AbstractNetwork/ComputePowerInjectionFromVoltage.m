function [P_inj_array,Q_inj_array] = ComputePowerInjectionFromVoltage(obj,U_array,T_array)
% Compute power injection for a given voltage profile
%
% Synopsis::
%
%   [P_inj_array,Q_inj_array] = network.ComputePowerInjectionFromVoltage(U_array,T_array)
%
% Description:
%   This method computes power injection based on the power flow equation.
%
%   .. math::
%
%       S_{inj} = diag(V)*conj(Y_{bus}*V)
%
% Arguments:
%   U_array (double): :term:`Phase-consistent array` with voltage mangitudes
%   T_array (double): :term:`Phase-consistent array` with voltage angles
%
% Returns:
%
%   - **P_inj_array** (double) - :term:`Phase-consistent array` with active power injection
%   - **Q_inj_array** (double) - :term:`Phase-consistent array` with reactive power injection

% .. Line with 80 characters for reference #####################################

I_inj = obj.ComputeCurrentInjectionFromVoltage(U_array,T_array);

V = uot.PolarToComplex(U_array,T_array);
S_inj = V.*conj(I_inj);

P_inj_array = real(S_inj);
Q_inj_array = imag(S_inj);
end