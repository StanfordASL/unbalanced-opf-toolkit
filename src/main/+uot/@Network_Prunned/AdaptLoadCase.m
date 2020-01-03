function load_case = AdaptLoadCase(obj,load_case_full,u_pcc_array,t_pcc_array)
[U_array_full,T_array_full] = load_case_full.SolvePowerFlow(u_pcc_array,t_pcc_array);

network_full = obj.network_full;

% Each cut link is replaced by a constant power load corresponding to the
% power going through it.
[~,~,S_link_from_full_array,~] = network_full.ComputeLinkCurrentsAndPowers(U_array_full,T_array_full);

n_cut_link_name_cell = numel(obj.cut_link_name_cell);

load_spec_additional_cell = cell(n_cut_link_name_cell,1);

n_time_step = load_case_full.spec.n_time_step;

for i_cut_link_name_cell = 1:n_cut_link_name_cell
    cut_link_name = obj.cut_link_name_cell{i_cut_link_name_cell};

    i_link_full = network_full.GetLinkNumber(cut_link_name);
    link_phase_from_full = network_full.link_has_phase_from(i_link_full,:);

    s_cut_link_va = S_link_from_full_array(i_link_full,link_phase_from_full,:)*obj.spec.s_base_va;

    from_i_full = network_full.link_data_array(i_link_full).from_i;

    bus_from_spec = network_full.bus_data_array(from_i_full).spec;

    phase_primary = logical([1,1,1]);

    switch class(bus_from_spec)
        case 'uot.BusSpec_Unbalanced'
            link_phase_in_load = link_phase_from_full(phase_primary);

        otherwise
            error('Unexpected class %s',class(bus_from_spec))
    end

    n_link_phase_in_load = numel(link_phase_in_load);

    s_y_va = zeros(n_time_step,n_link_phase_in_load);

    s_y_va(:,link_phase_in_load) = s_cut_link_va;

    from = network_full.bus_data_array(from_i_full).name;
    load_spec_additional_cell{i_cut_link_name_cell} = uot.LoadZipSpec(from,'s_y_va',s_y_va);
end

load_spec_additional_array = vertcat(load_spec_additional_cell{:});

% Remove all loads connected to buses which were removed
load_spec_full_array = load_case_full.spec.load_spec_array;

load_spec_full_bus_name_cell = {load_spec_full_array.bus}.';

load_spec_full_bus_removed = obj.removed_bus_name_map.isKey(load_spec_full_bus_name_cell);

load_spec_array = [
    % Keep the loads which are not connected to removed buses
    load_spec_full_array(~load_spec_full_bus_removed);
    % Add addtional loads from cut links
    load_spec_additional_array;
];

% Recall that LoadCaseZIPspec is a value class
spec = load_case_full.spec;
% Replace load_spec_array
spec.load_spec_array = load_spec_array;

load_case = uot.LoadCaseZIP(spec,obj);

if obj.validate
    [U_array,T_array,p_pcc_array,q_pcc_array] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);

    n_phase = obj.n_phase;

    bus_in_orginal = obj.GetBusInOriginal();

    U_array_ref = U_array_full(bus_in_orginal,1:n_phase,:);
    T_array_ref = T_array_full(bus_in_orginal,1:n_phase,:);

    V_array = uot.PolarToComplex(U_array,T_array);
    V_ref_array = uot.PolarToComplex(U_array_ref,T_array_ref);

    V_delta_array = abs(V_array - V_ref_array);

    V_delta_array_stack = uot.StackPhaseConsistent(V_delta_array,obj.bus_has_phase);

    V_delta_max_at_timestep = max(V_delta_array_stack,[],1);
    [V_delta_max,i_time_step] = max(V_delta_max_at_timestep);

    if V_delta_max > obj.validate_tol
        error('Validation failed, error = %e at i_time_step = %i.\n',V_delta_max,i_time_step);
    else
        if obj.verbose
            fprintf('Load validation passed, max error = %e.\n',V_delta_max);
        end
    end
end

end