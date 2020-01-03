function [U_array,T_array, p_pcc_array, q_pcc_array,extra_data] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
% |static| Approximately solve power flow
%
% Synopsis::
%
%   [U_array,T_array,p_pcc_array,q_pcc_array,extra_data] = PowerFlowSurrogate_Bernstein2017_LP_3.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array)
%   [U_array,T_array,p_pcc_array,q_pcc_array,extra_data] = PowerFlowSurrogate_Bernstein2017_LP_3.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,U_ast,T_ast)
%
% Description:
%   Compute an approximate solution to the power flow equation using eqs. 5a and 5c in :cite:`Bernstein2017`.
%   Additionally, use eq. 5c together with eq. 9 or 12 to compute another two approximations of voltage magnitude.
%
%   If no additional arguments are passed, the solution is computed by linearizing at the flat voltage solution.
%   Alternatively, the linearization can be done at an arbitrary voltage.
%
% Arguments:
%   load_case (|uot.LoadCasePy|): Load case for which power flow will be approximately solved
%   u_pcc_array (double): Array(n_phase,n_time_step) of voltage magnitudes at the |pcc|
%   t_pcc_array (double): Array(n_phase,n_time_step) of voltage angles at the |pcc|
%   U_ast (double): :term:`Phase-consistent array` (n_bus,n_phase) with voltage magnitudes for linearization
%   T_ast (double): :term:`Phase-consistent array` (n_bus,n_phase) with voltage angles for linearization
%
% Returns:
%
%   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
%   - **T_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage angles
%   - **p_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with active power injection at the |pcc|
%   - **q_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with reactive power injection at the |pcc|
%   - **extra_data** (struct) - Struct with fields U_array_eq9 and U_array_eq12 containing the other two approximations of voltage magnitude.
%
% See Also:
%   :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper<+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper>`
%

validateattributes(load_case,{'uot.LoadCasePy'},{'scalar'},mfilename,'load_case',1);

network = load_case.network;

n_time_step = load_case.spec.n_time_step;
n_phase = network.n_phase;

validateattributes(u_pcc_array,{'double'},{'size',[n_time_step,n_phase]},mfilename,'u_pcc_array',2);
validateattributes(t_pcc_array,{'double'},{'size',[n_time_step,n_phase]},mfilename,'t_pcc_array',3);

n_varargin = numel(varargin);

switch n_varargin
    case 0
        % Linearize at flat voltage
        linearization_point = uot.enum.CommonLinearizationPoints.FlatVoltage;
        [U_ast,T_ast] = linearization_point.GetVoltageAtLinearizationPoint(load_case,u_pcc_array,t_pcc_array);

    case 2
        U_ast = varargin{1};
        T_ast = varargin{2};

        validate_phase_consistency_h = @(x) uot.AssertPhaseConsistency(x,network.bus_has_phase);

        uot.ValidateAttributes(U_ast,{'double'},{'size',[nan,nan,1],validate_phase_consistency_h},mfilename,'U_ast',4);
        uot.ValidateAttributes(T_ast,{'double'},{'size',[nan,nan,1],validate_phase_consistency_h},mfilename,'T_ast',5);
    otherwise
        error('Invalid number of arguments.')
end

% Compute x_y
% Loads are negative power injections
S_inj_array = -load_case.S_y;
P_inj_array = real(S_inj_array);
Q_inj_array = imag(S_inj_array);

% x_y is the phase-consistent stack (see glossary) excluding the pcc (bus 1)
x_y = [uot.StackPhaseConsistent(P_inj_array(2:end,:,:),network.bus_has_phase(2:end,:,:));uot.StackPhaseConsistent(Q_inj_array(2:end,:,:),network.bus_has_phase(2:end,:,:))];

[x_y_ast,V_ast_nopcc_stack] = PowerFlowSurrogate_Bernstein2017_LP_3.GetLinearizationXy(load_case,U_ast,T_ast);

[~,~,w] = network.ComputeNoLoadVoltage(u_pcc_array,t_pcc_array);

% Compute voltage according to eq. 5a
M_y = PowerFlowSurrogate_Bernstein2017_LP_3.ComputeMyMatrix(network,V_ast_nopcc_stack);

V_nopcc_array_stack = M_y*x_y + w;

% Add pcc voltage
v_pcc_array = uot.PolarToComplex(u_pcc_array,t_pcc_array);

V_array_stack = [v_pcc_array.';V_nopcc_array_stack];

V_array = uot.UnstackPhaseConsistent(V_array_stack,network.bus_has_phase);

[U_array,T_array] = uot.ComplexToPolar(V_array);

% Compute pcc power injection according to eq. 5c and 13
s_pcc_array = zeros(n_time_step,network.n_phase);

for i = 1:n_time_step
    v_pcc_i = v_pcc_array(i,:).';
    G_y = diag(v_pcc_i)*conj(network.Ybus_SN)*conj(M_y);

    c = diag(v_pcc_i)*(conj(network.Ybus_SS)*conj(v_pcc_i) + conj(network.Ybus_SN)*conj(w(:,i)));

    s_pcc_array(i,:) = G_y*x_y(:,i) + c;
end

p_pcc_array = real(s_pcc_array);
q_pcc_array = imag(s_pcc_array);

% In addition to the results from standard power flow, the paper
% presents 2 approaches to approximate the magnitude of the voltages in the
% PQ nodes: using eq. 9 and eq. 12.
% We include them here so that we can test them.

% Approach from eq. 9
U_array_eq9 = PowerFlowSurrogate_Bernstein2017_LP_3.ComputeVoltageMagnitudeWithEq9(network,u_pcc_array,x_y,x_y_ast,V_ast_nopcc_stack,M_y);

% Approach from eq. 12
U_array_eq12 = zeros(network.n_bus,network.n_phase,n_time_step);

for i = 1:n_time_step
    w_i = w(:,i);
    W = diag(w_i);

    K_y_eq12 = abs(W)*real(inv(W)*M_y);

    b_eq12 = abs(w_i);

    U_stack_pre_eq12 = K_y_eq12*x_y(:,i) + b_eq12;

    U_stack_eq12 = [u_pcc_array(i,:).';U_stack_pre_eq12];

    U_array_eq12(:,:,i) = uot.UnstackPhaseConsistent(U_stack_eq12,network.bus_has_phase);
end

extra_data.U_array_eq9 = U_array_eq9;
extra_data.U_array_eq12 = U_array_eq12;
end


















