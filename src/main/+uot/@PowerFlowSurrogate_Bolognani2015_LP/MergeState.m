function state_vector_array = MergeState(U_array_stack,T_array_stack,P_inj_array_stack,Q_inj_array_stack)
% This function is static
state_vector_array = [U_array_stack; T_array_stack; P_inj_array_stack; Q_inj_array_stack];
end