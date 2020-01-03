function U_array_eq9 = ComputeVoltageMagnitudeWithEq9(network,u_pcc_array,x_y_array,x_y_ast,V_ast_nopcc_stack,M_y)
% |static|, |private| Computes the voltage magnitude according to eqs. 5b and 9 in :cite:`Bernstein2017`
%
% Synopsis::
%
%   U_array_eq9 = PowerFlowSurrogate_Bernstein2017_LP_3.ComputeVoltageMagnitudeWithEq9(network,u_pcc_array,x_y,x_y_ast,V_ast_nopcc_stack,M_y)
%
% Description:
%
% Arguments:
%   network (|uot.Network_Unbalanced|): Power network
%   u_pcc_array (double): Array(n_phase,n_time_step) of voltage magnitudes at |pcc|
%   x_y_array (double): Array of power injections (according to definition in paper)
%   x_y_ast (double): Array of power injections at linearization point
%   V_ast_nopcc_stack (double): :term:`phase-consistent stack<Phase-consistent stack>` with complex voltages at the linearization point (excluding those for the |pcc|)
%   M_y (double): M_y matrix defined below eq. 7
%
% Returns:
%
%   - **U_array_eq9** (double) - :term:`phase-consistent array<Phase-consistent array>` of voltage magnitudes

% .. Line with 80 characters for reference #####################################

V_ast_nopcc_stack_abs = abs(V_ast_nopcc_stack);
K_y_eq9 =  inv(diag(V_ast_nopcc_stack_abs))*real(diag(conj(V_ast_nopcc_stack))*M_y);
b_eq9 = V_ast_nopcc_stack_abs - K_y_eq9*x_y_ast;

U_array_stack_nopcc_eq9 = K_y_eq9*x_y_array + b_eq9;

U_array_stack_eq9 = [u_pcc_array.';U_array_stack_nopcc_eq9];

U_array_eq9 = uot.UnstackPhaseConsistent(U_array_stack_eq9,network.bus_has_phase);
end