function [V_ref_array,V_ref_array_v] = ParseVoltageData(obj)
% Reads voltage data from Gridlabd and places them in arrays

file_name = obj.spec.PrependUOToutputDirFull(obj.spec.file_name_voltage_data);

[time_stamp_array,data_table_cell] = uot.ModelImporter_Gridlabd.ParseTimeSeriesData(file_name);
obj.ValidateTimeStampArray(time_stamp_array);

V_ref_array_v = zeros(obj.network.n_bus,obj.network.n_phase,obj.spec.n_time_step);

phase_primary = obj.network.phase_primary;

for i_time_step = 1:obj.spec.n_time_step
    data_table = data_table_cell{i_time_step};

    for i_row = 1:size(data_table,1)

        bus_name = data_table.Name{i_row};

        bus_number = obj.network.GetBusNumber(bus_name);

        v_ref_pre_v = zeros(1,obj.network.n_phase);

        if isa(obj.network,'uot.Network_Splitphased') && obj.network.bus_has_split_phase(bus_number)
            phase_secondary = obj.network.phase_secondary;

            v_ref_pre_v(phase_secondary) = [data_table.V_1(i_row),data_table.V_2(i_row)];
        else
            v_ref_pre_v(phase_primary) = [data_table.V_1(i_row),data_table.V_2(i_row),data_table.V_3(i_row)];
        end

         % In Gridlabd voltage of missing phases is set to zero. In our convention, we use nan.
        v_ref_v = v_ref_pre_v;
        v_ref_v(v_ref_v == 0) = uot.ComplexNan();

        V_ref_array_v(bus_number,:,i_time_step) = v_ref_v;
    end
end

% Verify that we did not miss anything
uot.AssertPhaseConsistency(V_ref_array_v,obj.network.bus_has_phase);

V_ref_array = V_ref_array_v./obj.network.U_base_v;
end