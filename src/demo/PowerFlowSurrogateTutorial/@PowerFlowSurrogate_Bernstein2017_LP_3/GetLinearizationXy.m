function [x_y_ast,V_ast_nopcc_stack] = GetLinearizationXy(load_case,U_ast,T_ast)
% |private|, |static| Returns the linearization power injections at the linearization point as defined above eq. 5 in :cite:`Bernstein2017`
%
% Synopsis::
%
%   [U_ast,T_ast] = PowerFlowSurrogate_Bernstein2017_LP_3.GetLinearizationVoltage(load_case,U_ast,T_ast)
%
% Arguments:
%   U_ast (double): :term:`Phase-consistent array` (n_bus,n_phase) with voltage magnitudes at the linearization point
%   T_ast (double): :term:`Phase-consistent array` (n_bus,n_phase) with voltage angles at the linearization point
%
% Returns:
%
%   - **x_y_ast** (double) - Array of power injections at linearization point
%   - **V_ast_nopcc_stack** (double) - :term:`phase-consistent stack<Phase-consistent stack>` with complex voltages at the linearization point (excluding those for the |pcc|)
%

network = load_case.network;

V_ast = uot.PolarToComplex(U_ast,T_ast);
% Remove pcc
V_ast_nopcc_stack = uot.StackPhaseConsistent(V_ast(2:end,:,:),network.bus_has_phase(2:end,:,:));

[P_ast,Q_ast] = network.ComputePowerInjectionFromVoltage(U_ast,T_ast);
x_y_ast = [uot.StackPhaseConsistent(P_ast(2:end,:,:),network.bus_has_phase(2:end,:,:));uot.StackPhaseConsistent(Q_ast(2:end,:,:),network.bus_has_phase(2:end,:,:))];
end