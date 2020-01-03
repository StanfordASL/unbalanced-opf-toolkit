function constraint_array = GetConstraintArray(obj)
% Currently, we do not support networks with shunts. It is possible to generalize this implementation
% to support them by following an approach like that of Zhao2017, eq. 8d

network = obj.opf_problem.load_case.network;
uot.PowerFlowSurrogate_Gan2014.WarnIfNetworkHasShunts(network);

n_time_step = obj.opf_problem.n_time_step;

assert(network.is_radial,'PowerFlowSurrrogate_Gan2014 requires a radial network.')

[adjacency_list_cell,inv_adjacency_list_cell] = network.ComputeAdjacencyList();

% In a radial network, each bus has only one parent
assert(isempty(inv_adjacency_list_cell{1}),'PCC must not have a parent');
n_parents = cellfun(@numel,inv_adjacency_list_cell);
assert(all(n_parents(2:end) == 1),'All buses other than PCC must have exactly one parent');

power_balance_constraint_cell = cell(n_time_step,1);

[P_inj_array,Q_inj_array] = obj.opf_problem.ComputeNodalPowerInjection();
S_inj_array = P_inj_array + 1i*Q_inj_array;

% There is no need to sum over parent buses because each bus has only one parent
for i_time_step = 1:n_time_step
    power_balance_cell = cell(network.n_bus,1);

    % Eq 10a
    for i_bus = 1:network.n_bus
        bus_phase = network.bus_data_array(i_bus).phase;

        if i_bus == 1
            s_PCC = S_inj_array(i_bus,:,i_time_step).';
            power_balance = s_PCC;
        else
            bus_upstream = inv_adjacency_list_cell{i_bus};
            link_upstream = network.GetLinkNumber(bus_upstream,i_bus);

            S_upstream_diag = diag(obj.decision_variables.S_link_cell{link_upstream,i_time_step});
            Z_upstream_pre = network.link_data_array(link_upstream).Z_from;
            Z_upstream = obj.AdjustZlink(Z_upstream_pre,obj.Z_link_norm_min);
            L_upstream = obj.decision_variables.L_link_cell{link_upstream,i_time_step};

            s_bus = S_inj_array(i_bus,bus_phase,i_time_step).';

            power_balance = S_upstream_diag - diag(Z_upstream*L_upstream) + s_bus;
        end

        for bus_downstream = adjacency_list_cell{i_bus}().'
            link_downstream = network.GetLinkNumber(i_bus,bus_downstream);

            sink_phase = network.bus_data_array(bus_downstream).phase;

            phase_match = sink_phase(bus_phase);

            S_downstream_diag = diag(obj.decision_variables.S_link_cell{link_downstream,i_time_step});

            if all(phase_match)
                % subsref calls for sdpvar can get expensive so we save it
                power_balance = power_balance - S_downstream_diag;
            else
                power_balance(phase_match) = power_balance(phase_match) - S_downstream_diag;
            end
        end

        power_balance_cell{i_bus} = power_balance;
    end

    % We do it this way to have a single power balance constraint per time step
    % instead of an array of them.
    power_balance_constraint = vertcat(power_balance_cell{:}) == 0;
    power_balance_constraint = uot.TagConstraintIfNonEmpty(power_balance_constraint,sprintf('Power balance constraint, time_step = %d',i_time_step));

    power_balance_constraint_cell{i_time_step} = power_balance_constraint;
end

power_balance_constraint_array = vertcat(power_balance_constraint_cell{:});

% Eq 10 e and f
ohm_law_constraint_cell = cell(network.n_link,n_time_step);

for i_time_step = 1:n_time_step
    for i_link = 1:network.n_link
       from_i = network.link_data_array(i_link).from_i;
       to_i = network.link_data_array(i_link).to_i;

       from_phase = network.bus_data_array(from_i).phase;

       link_phase = network.link_data_array(i_link).phase_from;

       phase_match = link_phase(from_phase);

       if all(phase_match)
            % subsref calls for sdpvar can get expensive so we save it
            V_bus_from = obj.decision_variables.V_bus_cell{from_i,i_time_step};
       else
            V_bus_from = obj.decision_variables.V_bus_cell{from_i,i_time_step}(phase_match,phase_match);
       end

       V_bus_sink = obj.decision_variables.V_bus_cell{to_i,i_time_step};

       S_link = obj.decision_variables.S_link_cell{i_link,i_time_step};
       L_link = obj.decision_variables.L_link_cell{i_link,i_time_step};

       % Note that according to Bazrafshan2017 Theorem 1, Y_from = Y_to.'.
       % So no need to worry about Z_from vs Z_to.

       Z_link_pre = network.link_data_array(i_link).Z_from;
       Z_link = obj.AdjustZlink(Z_link_pre,obj.Z_link_norm_min);

       ohm_law_constraint = V_bus_sink ==  V_bus_from -(S_link*Z_link' + Z_link*S_link') + Z_link*L_link*Z_link';
       ohm_law_constraint_cell{i_link,i_time_step} = uot.TagConstraintIfNonEmpty(ohm_law_constraint,sprintf('Ohm law link %d, time_step = %d',i_link,i_time_step));
    end
end

ohm_law_constraint_array = vertcat(ohm_law_constraint_cell{:});

% Eq 10 c
V_PCC_constraint_cell = cell(1,n_time_step);
for i_time_step = 1:n_time_step
    v_pcc = obj.opf_problem.spec.pcc_voltage_spec.v_pcc_array(i_time_step,:);

    V_bus_pcc_pre = v_pcc(:)*v_pcc(:)';
    % V is hermitian so diagonal should be real. Here we get rid of
    % numerical noise that leads to problems for yalmip.
    V_bus_pcc = V_bus_pcc_pre - 1i*diag(diag(imag(V_bus_pcc_pre)));

    V_PCC_constraint = V_bus_pcc == obj.decision_variables.V_bus_cell{1,i_time_step};
    V_PCC_constraint_cell{i_time_step} = uot.TagConstraintIfNonEmpty(V_PCC_constraint,sprintf('V_PCC constraint, time_step = %d',i_time_step));
end
V_PCC_constraint_array = vertcat(V_PCC_constraint_cell{:});

% Power quality constraints
voltage_magnitude_spec = obj.opf_problem.spec.voltage_magnitude_spec;

% Eq 10 d
% Skip PCC
U_sq_cell = cellfun(@(V_bus) diag(V_bus),obj.decision_variables.V_bus_cell(2:end,:),'UniformOutput',false);

% Non-enforced u_min constraint is given as 0. Here we convert it to -inf so that
% CreateBoxConstraint ignores the constraint
if voltage_magnitude_spec.u_min == 0
    u_min_sq = -inf;
else
    u_min_sq = voltage_magnitude_spec.u_min.^2;
end

u_max_sq = voltage_magnitude_spec.u_max.^2;

U_sq_box_constraint_cell = cell(1,n_time_step);

for i_time_step = 1:n_time_step
   U_sq_stack = vertcat(U_sq_cell{:,i_time_step});
   U_sq_box_constraint_cell{i_time_step} = uot.CreateBoxConstraint(U_sq_stack,u_min_sq,u_max_sq,sprintf('U_sq, time_step = %d',i_time_step));
end

U_sq_box_constraint_array = vertcat(U_sq_box_constraint_cell{:});

constraint_array = [
    ohm_law_constraint_array;
    power_balance_constraint_array;
    V_PCC_constraint_array;
    U_sq_box_constraint_array;
    ];
end