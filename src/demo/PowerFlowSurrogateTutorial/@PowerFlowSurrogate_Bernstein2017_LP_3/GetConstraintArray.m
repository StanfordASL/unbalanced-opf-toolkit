function constraint_array = GetConstraintArray(obj)
% |protected| Creates the array of constraints that result from applying the power flow surrogate to the |opf| problem
%
% Synopsis::
%
%   constraint_array = pf_surrogate.GetConstraintArray()
%
% Description:
%   The power flow surrogate implements the following constraints:
%   - Voltage magnitude limits
%   - Power injection at pcc
%   - Voltage at |pcc|
%
% Returns:
%
%   - **constraint_array** (constraint) - Array of constraints

% .. Line with 80 characters for reference #####################################

load_case = obj.opf_problem.load_case;
network = load_case.network;
n_time_step = obj.opf_problem.n_time_step;

% This power injection includes both controllable and uncontrollable loads
[P_inj_array,Q_inj_array] = obj.opf_problem.ComputeNodalPowerInjection();

% At this point, we need to define decision variables over which we will optimize.
% Most power flow surrogates need, at the very least, decision variables for voltage.
% Similar to uot.PowerFlowSurrogate_Bolognani2015_LP we use U_array_stack.
% However, we do not create a  T_array_stack because we do not need to keep
% track of phase information. This merits some explanation: in principle
% we could keep track of phase using eq. 5a. However, there is little
% use in doing so since phase does not figure in any of the relevant constraints.
U_array_stack = obj.decision_variables.U_array_stack;

% First, we implement the constraint on voltage at the pcc.
% By convention, bus 1 is the pcc
n_phase_pcc = network.n_phase_in_bus(1);

u_pcc_array = obj.opf_problem.u_pcc_array;
t_pcc_array = obj.opf_problem.t_pcc_array;

u_pcc_constraint = U_array_stack(1:n_phase_pcc,:) == u_pcc_array.';
% Tagging the constraints makes debugging much easier
u_pcc_constraint = uot.TagConstraintIfNonEmpty(u_pcc_constraint,'u_pcc_constraint');

% Second, we need to specify constraints on voltage magnitude.
% The paper presents two ways of doing this: with eq. 9 or eq. 12.
% We choose eq. 9 because in Figures 3 and 7, it shows better performance
% near kappa = 1 which is the nominal operating point.
% Our implementation of SolveApproxPowerFlowAlt shows us the way to go

x_y = [uot.StackPhaseConsistent(P_inj_array(2:end,:,:),network.bus_has_phase(2:end,:,:));uot.StackPhaseConsistent(Q_inj_array(2:end,:,:),network.bus_has_phase(2:end,:,:))];

% We create the method GetLinearizationXy to avoid code duplication with
% SolveApproxPowerFlowAlt. The method has to be static so that we can call it
% from SolveApproxPowerFlowAlt which is static.
%
% We add linearization_point as a public property. We add it to the power flow surrogate
% and not to the spec to respect the principle of separating the opf_problem from
% the way we solve it.
[U_ast,T_ast] = obj.GetLinearizationVoltage();
[x_y_ast,V_ast_nopcc_stack] = PowerFlowSurrogate_Bernstein2017_LP_3.GetLinearizationXy(load_case,U_ast,T_ast);

% Again, we create ComputeMyMatrix and ComputeVoltageMagnitudeWithEq9 to avoid code duplication
M_y = PowerFlowSurrogate_Bernstein2017_LP_3.ComputeMyMatrix(network,V_ast_nopcc_stack);
U_array_eq9 = PowerFlowSurrogate_Bernstein2017_LP_3.ComputeVoltageMagnitudeWithEq9(network,u_pcc_array,x_y,x_y_ast,V_ast_nopcc_stack,M_y);

U_array_stack_eq9 = uot.StackPhaseConsistent(U_array_eq9,network.bus_has_phase);

% Now we set our decision variables U_array_stack to match U_array_stack_eq9.
% We exclude the pcc because we defined it above.
voltage_magnitude_def_constraint = U_array_stack((n_phase_pcc + 1):end,:) == U_array_stack_eq9((n_phase_pcc + 1):end,:);
voltage_magnitude_def_constraint = uot.TagConstraintIfNonEmpty(voltage_magnitude_def_constraint,'voltage_magnitude_def_constraint');

% Now we can define the constraint on voltage magnitude as done in
% uot.PowerFlowSurrogate_Bolognani2015_LP

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
% first n_phase_pcc elements in U_array_stack)
U_box_constraint = uot.CreateBoxConstraint(U_array_stack((n_phase_pcc+1):end,:),u_min,u_max,'U_box_constraint');

% Finally, we need to couple the pcc load to the rest of the problem. We do this
% through eqs. 5c and 13
v_pcc_array = uot.PolarToComplex(u_pcc_array,t_pcc_array);
[~,~,w] = network.ComputeNoLoadVoltage(u_pcc_array,t_pcc_array);

% We need to be careful when pre-allocating arrays for sdpvars
% s_pcc_array will be an sdpvar because x_y is an sdpvar. The key issue
% is that by doing
% A = zeros(2,2);
% A(1,1) = sdpvar(1,1)
% The sdpvar appears as a double nan in A which is useless.
% For more information see https://yalmip.github.io/naninmodel/
%
% One way of doing this is creating a cell array and then concatenating the
% contents.
s_pcc_cell = cell(n_time_step,1);

for i = 1:n_time_step
    v_pcc_i = v_pcc_array(i,:).';
    G_y = diag(v_pcc_i)*conj(network.Ybus_SN)*conj(M_y);

    c = diag(v_pcc_i)*(conj(network.Ybus_SS)*conj(v_pcc_i) + conj(network.Ybus_SN)*conj(w(:,i)));

    % Transpose to keep covension of phases being along dimension 2
    s_pcc_cell{i} = (G_y*x_y(:,i) + c).';
end

s_pcc_array = vertcat(s_pcc_cell{:});

p_pcc_array = real(s_pcc_array);
q_pcc_array = imag(s_pcc_array);

% Recall that bus 1 is the pcc. Further, we permute the dimensions
% so that they match (p_pcc_array has time along dimension 1 and P_inj_array
% has time along dimension 3).
p_pcc_array_constraint = p_pcc_array == uot.PermuteDims1and3(P_inj_array(1,:,:));
p_pcc_array_constraint = uot.TagConstraintIfNonEmpty(p_pcc_array_constraint,'p_pcc_array_constraint');

q_pcc_array_constraint = q_pcc_array == uot.PermuteDims1and3(Q_inj_array(1,:,:));
q_pcc_array_constraint = uot.TagConstraintIfNonEmpty(q_pcc_array_constraint,'q_pcc_array_constraint');

constraint_array = [
    u_pcc_constraint;
    voltage_magnitude_def_constraint;
    U_box_constraint;
    p_pcc_array_constraint;
    q_pcc_array_constraint
];
end















