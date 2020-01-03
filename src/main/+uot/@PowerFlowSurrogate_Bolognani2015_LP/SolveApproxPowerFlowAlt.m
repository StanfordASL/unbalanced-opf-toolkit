function [U_array,T_array, p_pcc_array, q_pcc_array] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
% This function is static
% [...] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array) % Linearizes at flat voltage
% [...] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,U_ast,T_ast) % Linearizes at U_ast, T_ast

validateattributes(load_case,{'uot.LoadCasePy'},{'scalar'},mfilename,'load_case',1);

network = load_case.network;

n_time_step = load_case.spec.n_time_step;
n_phase = network.n_phase;

validateattributes(u_pcc_array,{'double'},{'size',[n_time_step,n_phase]},mfilename,'u_pcc_array',2);
validateattributes(t_pcc_array,{'double'},{'size',[n_time_step,n_phase]},mfilename,'t_pcc_array',3);

n_varargin = numel(varargin);

switch n_varargin
    case 0
        linearization_point = uot.enum.CommonLinearizationPoints.FlatVoltage;
        [U_ast, T_ast] = linearization_point.GetVoltageAtLinearizationPoint(load_case,u_pcc_array,t_pcc_array);
        state_vector_ast = uot.PowerFlowSurrogate_Bolognani2015_LP.GetStateVectorAtVoltage(network,U_ast,T_ast);

    case 2
        U_ast = varargin{1};
        T_ast = varargin{2};

        validate_phase_consistency_h = @(x) uot.AssertPhaseConsistency(x,network.bus_has_phase);

        uot.ValidateAttributes(U_ast,{'double'},{'size',[nan,nan,1],validate_phase_consistency_h},mfilename,'U_ast',4);
        uot.ValidateAttributes(T_ast,{'double'},{'size',[nan,nan,1],validate_phase_consistency_h},mfilename,'T_ast',5);

        state_vector_ast = uot.PowerFlowSurrogate_Bolognani2015_LP.GetStateVectorAtVoltage(network,U_ast,T_ast);

    otherwise
        error('Invalid number of arguments.')
end

state_vector_ast_array = repmat(state_vector_ast,1,n_time_step);

% Loads are negative power injections
S_inj_array = -load_case.S_y;
P_inj_array = real(S_inj_array);
Q_inj_array = imag(S_inj_array);

P_inj_array_stack = uot.StackPhaseConsistent(P_inj_array,network.bus_has_phase);
Q_inj_array_stack = uot.StackPhaseConsistent(Q_inj_array,network.bus_has_phase);

% From Eq. 4
A_ast = uot.PowerFlowSurrogate_Bolognani2015_LP.GetAmatrix(network,state_vector_ast);

% From above Eq. 12
[C_ast,d_ast] = uot.PowerFlowSurrogate_Bolognani2015_LP.GetBusModel(network,state_vector_ast,P_inj_array_stack,Q_inj_array_stack,u_pcc_array,t_pcc_array);

M = [A_ast; C_ast];
b = [zeros(size(A_ast,1),n_time_step); d_ast];

delta_x_array = M\b;

state_vector_array = state_vector_ast_array + delta_x_array;

[U_stack_array, T_stack_array, P_stack_array, Q_stack_array] = uot.PowerFlowSurrogate_Bolognani2015_LP.SplitState(state_vector_array);

% Transpose to follow convention that dimension 2 is for phases
p_pcc_array = P_stack_array(1:network.n_phase,:).';
q_pcc_array = Q_stack_array(1:network.n_phase,:).';

U_array = uot.UnstackPhaseConsistent(U_stack_array,network.bus_has_phase);
T_array = uot.UnstackPhaseConsistent(T_stack_array,network.bus_has_phase);
end