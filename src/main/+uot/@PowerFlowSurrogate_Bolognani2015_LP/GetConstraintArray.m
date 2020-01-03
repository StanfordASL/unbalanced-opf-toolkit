function constraint_array = GetConstraintArray(obj)
network = obj.opf_problem.load_case.network;
n_time_step = obj.opf_problem.n_time_step;

[P_inj_array,Q_inj_array] = obj.opf_problem.ComputeNodalPowerInjection();

P_inj_array_stack = uot.StackPhaseConsistent(P_inj_array,network.bus_has_phase);
Q_inj_array_stack = uot.StackPhaseConsistent(Q_inj_array,network.bus_has_phase);

U_array_stack = obj.decision_variables.U_array_stack;
T_array_stack = obj.decision_variables.T_array_stack;

state_vector_array = obj.MergeState(U_array_stack,T_array_stack,P_inj_array_stack,Q_inj_array_stack);

state_vector_ast = obj.GetStateVectorForLinearization();
state_vector_ast_array = repmat(state_vector_ast,1,n_time_step);

state_vector_delta_array = (state_vector_array - state_vector_ast_array);

% Power flow surrogate (Eq. 4)
A_ast = uot.PowerFlowSurrogate_Bolognani2015_LP.GetAmatrix(network,state_vector_ast);
b = zeros(size(A_ast,1),n_time_step);

if obj.scale_flag
    % Normalize the power flow surrogate equation using the real part of the
    % diagonal of Ybus
    Ybus_diag = diag(network.Ybus);
    Ybus_diag_real_inv = uot.Spdiag(real(1./Ybus_diag));

    A_norm = blkdiag(Ybus_diag_real_inv,Ybus_diag_real_inv);

    M = A_norm*A_ast;
else

    M = A_ast;
end

% Eq. 4
power_flow_constraint = M*state_vector_delta_array == b;
power_flow_constraint = uot.TagConstraintIfNonEmpty(power_flow_constraint,'power_flow_constraint');

% Bus model
% Reference voltage constraint
u_pcc_array = obj.opf_problem.u_pcc_array;
t_pcc_array = obj.opf_problem.t_pcc_array;

% Transpose so that dimensions match
n_phase_pcc = network.n_phase_in_bus(1);
u_pcc_constraint = U_array_stack(1:n_phase_pcc,:) == u_pcc_array.';
u_pcc_constraint = uot.TagConstraintIfNonEmpty(u_pcc_constraint,'u_pcc_constraint');

t_pcc_constraint = T_array_stack(1:n_phase_pcc,:) == t_pcc_array.';
t_pcc_constraint = uot.TagConstraintIfNonEmpty(t_pcc_constraint,'t_pcc_constraint');

bus_model_constraint_array = [
    u_pcc_constraint;
    t_pcc_constraint;
    ];

% Voltage magnitude bound
% Non-enforced u_min constraint is given as 0. Here we convert it to -inf so that
% CreateBoxConstraint ignores the constraint
voltage_magnitude_spec = obj.opf_problem.spec.voltage_magnitude_spec;

if voltage_magnitude_spec.u_min == 0
    u_min = -inf;
else
    u_min = voltage_magnitude_spec.u_min;
end

u_max = voltage_magnitude_spec.u_max;

% Note that voltage magnitude bounds does not apply to pcc (which are the
% first n_phase elements in U_array_stack)
n_phase_pcc = network.n_phase_in_bus(1);
U_box_constraint = uot.CreateBoxConstraint(U_array_stack((n_phase_pcc+1):end,:),u_min,u_max,'U_box_constraint');

constraint_array = [
    power_flow_constraint;
    bus_model_constraint_array;
    U_box_constraint;
    ];
end