function [p_pcc_ref_array,q_pcc_ref_array,p_pcc_ref_array_va,q_pcc_ref_array_va] = ParsePCCloadData(obj)
% Reads PCC load data from Gridlabd and places them in arrays

file_name = obj.spec.PrependUOToutputDirFull(obj.spec.file_name_pcc_load_data);

[time_stamp_array,data_table_cell] = uot.ModelImporter_Gridlabd.ParseTimeSeriesData(file_name);
obj.ValidateTimeStampArray(time_stamp_array);

n_time_step = obj.spec.n_time_step;

% TODO: replace this
n_phase_primary = sum(obj.network.phase_primary);

p_pcc_ref_array_va = zeros(n_time_step,n_phase_primary);
q_pcc_ref_array_va = zeros(n_time_step,n_phase_primary);

% Recall that by convention PCC is bus 1 in network
pcc_name = obj.network.bus_data_array(1).name;

for i_time_step = 1:n_time_step
    data_table = data_table_cell{i_time_step};
    assert(size(data_table,1) == 1,'The network has multiple swing buses. This is currently not supported.')

    assert(strcmp(data_table.Name{1},pcc_name),'Unexpected PCC bus name.');

    s_pcc_ref_va = [data_table.S_swing_1,data_table.S_swing_2,data_table.S_swing_3];

    p_pcc_ref_array_va(i_time_step,:) = real(s_pcc_ref_va);
    q_pcc_ref_array_va(i_time_step,:) = imag(s_pcc_ref_va);
end

p_pcc_ref_array = p_pcc_ref_array_va/obj.network.spec.s_base_va;
q_pcc_ref_array = q_pcc_ref_array_va/obj.network.spec.s_base_va;
end