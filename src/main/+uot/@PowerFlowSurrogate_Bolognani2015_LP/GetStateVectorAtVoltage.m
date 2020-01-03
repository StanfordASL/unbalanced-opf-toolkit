function state_vector = GetStateVectorAtVoltage(network,U,T)
% This function is static

V = uot.PolarToComplex(U,T);
V_stack = uot.StackPhaseConsistent(V,network.bus_has_phase);

[U_stack,T_stack] = uot.ComplexToPolar(V_stack);

S_ast_stack = diag(V_stack)*conj(network.Ybus*V_stack);

P_stack = real(S_ast_stack);
Q_stack = imag(S_ast_stack);
Q_stack(isnan(S_ast_stack)) = nan;

state_vector = uot.PowerFlowSurrogate_Bolognani2015_LP.MergeState(U_stack,T_stack,P_stack,Q_stack);
end