function I_inj_array = ComputeCurrentInjectionFromVoltage(obj,U_array,T_array)
% Compute current injection for a given voltage profile
%
% Synopsis::
%
%   I_inj_array = network.ComputeCurrentInjectionFromVoltage(U_array,T_array)
%
% Description:
%   This method implements Ohm´s law :math:`I_{inj} = Y_{bus}*V` to compute current injection
%   based on voltage.
%
% Arguments:
%   U_array (double): :term:`Phase-consistent array` with voltage magnitudes
%   T_array (double): :term:`Phase-consistent array` with voltage angles
%
% Returns:
%
%   - **I_inj_array** (double) - :term:`Phase-consistent array` with complex power injection

% .. Line with 80 characters for reference #####################################

V_array = uot.PolarToComplex(U_array,T_array);
V_array_stack = uot.StackPhaseConsistent(V_array,obj.bus_has_phase);

I_inj_array_stack = obj.Ybus*V_array_stack;

I_inj_array = uot.UnstackPhaseConsistent(I_inj_array_stack,obj.bus_has_phase);
end