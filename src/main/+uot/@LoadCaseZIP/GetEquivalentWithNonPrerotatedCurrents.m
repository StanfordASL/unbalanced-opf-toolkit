function obj_equiv = GetEquivalentWithNonPrerotatedCurrents(obj)
% GetEquivalentWithNonPrerotatedCurrents Converts a LoadCaseZip with pre-rotated currents (in i_y_a and i_d_a) to one with non pre-rotated currents
%   This only affects loads in primary buses. Loads on split-phased buses are not changed
%   Note that i_y_va and i_d_va are not changed since we do not consider pre-rotation there

if obj.spec.current_is_prerotated
    a = uot.FortescueOperator();

    v_base = obj.network.GetFlatVoltage();

    pre_rot_matrix_y = repmat(v_base./abs(v_base),obj.spec.n_time_step,1);

    delta_mat = uot.Delta();

    v_base_d = (delta_mat*v_base.').';
    pre_rot_matrix_d = repmat(v_base_d./abs(v_base_d),obj.spec.n_time_step,1);

    load_spec_array = obj.spec.load_spec_array;
    n_load_spec_array = numel(load_spec_array);

    load_spec_new_cell = cell(n_load_spec_array,1);

    for i_load_spec_array = 1:n_load_spec_array
        load_spec = obj.spec.load_spec_array(i_load_spec_array);

        bus = load_spec.bus;
        bus_number = obj.network.GetBusNumber(bus);

        % We do not change loads on split-phased notes
        if ~(isa(obj.network,'uot.Network_Splitphased') && obj.network.bus_has_split_phase(bus_number))
            if ~isempty(load_spec.i_y_a)
                load_spec.i_y_a = load_spec.i_y_a./pre_rot_matrix_y;
            end

            if ~isempty(load_spec.i_d_a)
                load_spec.i_d_a = load_spec.i_d_a./pre_rot_matrix_d;
            end
        end

        load_spec_new_cell{i_load_spec_array} = load_spec;
    end

   load_spec_new_array = vertcat(load_spec_new_cell{:});

    % Recall that uot.Spec is a value class
    spec_new = obj.spec;
    spec_new.load_spec_array = load_spec_new_array;
    spec_new.current_is_prerotated = false;

    obj_equiv = uot.LoadCaseZIP(spec_new,obj.network);
else
    warning('Currents are not pre-rotated. Returning same object.')
    obj_equiv = obj;
end
end