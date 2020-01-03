function A = GetAmatrix(network,state_vector_ast)
% This function is static
[U_ast_stack, T_ast_stack] = uot.PowerFlowSurrogate_Bolognani2015_LP.SplitState(state_vector_ast);

n_bus_has_phase = network.n_bus_has_phase;

N = blkdiag(speye(n_bus_has_phase),-speye(n_bus_has_phase));

V_ast_stack = uot.PolarToComplex(U_ast_stack,T_ast_stack);

I_ast_conj_stack = conj(network.Ybus*V_ast_stack);

I_ast_conj_stack_diag_bracket = BracketOperator(uot.Spdiag(I_ast_conj_stack));

V_ast_stack_diag_bracket = BracketOperator(uot.Spdiag(V_ast_stack));

R_v_ast = Rmatrix(U_ast_stack,T_ast_stack);

A_left = (I_ast_conj_stack_diag_bracket + V_ast_stack_diag_bracket*N*BracketOperator(network.Ybus))*R_v_ast;

A_right = -speye(2*n_bus_has_phase);

A = [A_left,A_right];
end

function M_bracket = BracketOperator(M)
M_bracket = [real(M),-imag(M);
    imag(M), real(M)];
end

function R = Rmatrix(u,t)
diag_sin_t = uot.Spdiag(sin(t));
diag_cos_t = uot.Spdiag(cos(t));
diag_u = uot.Spdiag(u);
R = [diag_cos_t, -diag_u*diag_sin_t;
    diag_sin_t, diag_u*diag_cos_t;
    ];
end