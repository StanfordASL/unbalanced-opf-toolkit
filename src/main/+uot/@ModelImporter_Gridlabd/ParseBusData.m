function bus_spec_array = ParseBusData(obj)
% Reads bus data from Gridlabd and creates bus_spec_array from them

file_name_bus_data_full = obj.spec.PrependUOToutputDirFull(obj.spec.file_name_bus_data);

bus_data_table = readtable(file_name_bus_data_full,'ReadRowNames',true);

phase_matrix = logical([bus_data_table.PhaseA,bus_data_table.PhaseB,bus_data_table.PhaseC]);
has_split_phase = logical([bus_data_table.PhaseS]);
is_swing = logical(bus_data_table.Is_Swing);

n_bus = size(bus_data_table,1);

bus_spec_cell = cell(n_bus,1);

for i_bus = 1:n_bus
    name = bus_data_table.Name{i_bus};
    phase = phase_matrix(i_bus,:);
    u_nom_v = bus_data_table.Volt_base(i_bus);

    if is_swing(i_bus)
        bus_spec = uot.BusSpec_Unbalanced(name,phase,u_nom_v,'bus_type',uot.enum.BusType.Swing);
    else
        if has_split_phase(i_bus)
            parent_phase = phase;

            % Typically split-phase buses have u_nom_v = 120
            if u_nom_v ~= 120
                if obj.spec.reset_u_nom_v_on_splitphased_buses
                    warning('Split-phase bus %s has u_nom_v = %d. Resetting to 120 V',name,u_nom_v);
                    u_nom_v = 120;
                else
                    warning('Split-phase bus %s has u_nom_v = %d.',name,u_nom_v);
                end
            end

            bus_spec = uot.BusSpec_Splitphased(name,parent_phase,u_nom_v);
        else
            bus_spec = uot.BusSpec_Unbalanced(name,phase,u_nom_v);
        end
    end

    bus_spec_cell{i_bus} = bus_spec;
end

bus_spec_array = vertcat(bus_spec_cell{:});
end