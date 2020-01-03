function [C_ast,d_ast] = GetBusModel(network,state_vector_ast,P_inj_array_stack,Q_inj_array_stack,u_pcc_array,t_pcc_array)
% This function is static

% This reflects section 4 of the paper

[U_ast_stack, T_ast_stack,P_ast_stack, Q_ast_stack] = uot.PowerFlowSurrogate_Bolognani2015_LP.SplitState(state_vector_ast);

n_time_step = size(P_inj_array_stack,2);

n_bus_has_phase = network.n_bus_has_phase;

C_ast = sparse(2*n_bus_has_phase,4*n_bus_has_phase);

% If P_inj_array_stack or Q_inj_array_stack are sdpvars, d_ast must
% also be an sdpvar.
if isa(P_inj_array_stack,'sdpvar') || isa(Q_inj_array_stack,'sdpvar')
    d_ast = sdpvar(2*n_bus_has_phase,n_time_step);
else
    d_ast = zeros(2*n_bus_has_phase,n_time_step);
end

% Following our convention, the first bus is the pcc
is_pcc_bus = false(network.n_bus,network.n_phase);
is_pcc_bus(1,:) = true;
is_pcc_bus_stack = uot.StackPhaseConsistent(is_pcc_bus,network.bus_has_phase);

for i_bus_with_phase = 1:n_bus_has_phase
    bus_indicator = zeros(1,n_bus_has_phase);
    bus_indicator(i_bus_with_phase) = 1;

    constraint_rows = (2*i_bus_with_phase-1):(2*i_bus_with_phase);

    % PCC bus
    if is_pcc_bus_stack(i_bus_with_phase)
        bus_mask = [1,0,0,0;
            0,1,0,0];
        d_ast(constraint_rows,:) = -[U_ast_stack(i_bus_with_phase) - u_pcc_array(:,i_bus_with_phase).';
            T_ast_stack(i_bus_with_phase) - t_pcc_array(:,i_bus_with_phase).';
            ];
    else
        %Bus_mask is the result of d g_h(x_h)/dx_h
        bus_mask = [0,0,1,0;
            0,0,0,1];
        d_ast(constraint_rows,:) = -[P_ast_stack(i_bus_with_phase) - P_inj_array_stack(i_bus_with_phase,:);
            Q_ast_stack(i_bus_with_phase) - Q_inj_array_stack(i_bus_with_phase,:);
            ];

    end

    bus_mask = sparse(bus_mask);

    %The kron product allows us to keep track of which
    %constraint applies to which bus.
    C_ast(constraint_rows,:) = kron(bus_mask,bus_indicator);
end
end