function [U_stack_array, T_stack_array, P_stack_array, Q_stack_array] = SplitState(state_vector_array)
% This function is static

n = size(state_vector_array,1)/4;

assert(n == round(n),'Invalid size of state_vector_array')

U_stack_array = state_vector_array(1:n,:);
T_stack_array = state_vector_array((n + 1):2*n,:);
P_stack_array = state_vector_array((2*n + 1):3*n,:);
Q_stack_array = state_vector_array((3*n + 1):4*n,:);
end