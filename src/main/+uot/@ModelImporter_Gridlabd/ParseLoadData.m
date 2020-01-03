function [load_case,load_case_prerot] = ParseLoadData(obj)
% Reads load data Gridlabd and places them in two LoadCaseZIP.
% One has non-pre-rotated currents, the other has them pre-rotated.
% The reason for this is that Gridlabd uses pre-rotated currents internally
% so its output has them as well.
% We keep both because they are useful for different things:
% load_case is better for solving power flow (it matches IEEE
% test cases better).
% load_case_prerot is useful to validate the imported data against
% Gridlab's powerflow solver.


file_name = obj.spec.PrependUOToutputDirFull(obj.spec.file_name_load_data);

[time_stamp_array,data_table_cell] = uot.ModelImporter_Gridlabd.ParseTimeSeriesData(file_name);
obj.ValidateTimeStampArray(time_stamp_array);

n_time_step = obj.spec.n_time_step;

load_zip_spec_array_cell = cell(n_time_step,1);

for i_time_step = 1:n_time_step
    [load_zip_spec_array_cell{i_time_step}] = ...
        ParseLoadDataBlock(data_table_cell{i_time_step},obj.network,...
        i_time_step,n_time_step);
end

load_zip_spec_array = vertcat(load_zip_spec_array_cell{:});
time_step_s = obj.spec.time_step_s;
n_time_step = obj.spec.n_time_step;

load_case_spec = uot.LoadCaseZIPspec(load_zip_spec_array,time_step_s,n_time_step);

% The output from Gridlab has prerotated currents
load_case_spec.current_is_prerotated = true;

load_case_prerot = uot.LoadCaseZIP(load_case_spec,obj.network);

load_case = load_case_prerot.GetEquivalentWithNonPrerotatedCurrents();
end

function load_zip_spec_array =  ParseLoadDataBlock(data_table,network,i_time_step,n_time_step)
n_load = size(data_table,1);

load_zip_spec_cell = cell(n_load,1);

for i_load = 1:n_load
    bus_name = data_table.Name{i_load};

    bus_number = network.GetBusNumber(bus_name);

    if isa(network,'uot.Network_Splitphased')
        has_split_phase = network.bus_has_split_phase(bus_number);
    else
        has_split_phase = false;
    end

    % Skip PCC
    if bus_number ~= 1

        % Recall that LoadCaseZIP adds all loads for a given bus. Thus, we add
        % only the load for this time step and leave all others at zero.

        if has_split_phase
            n_load_phase = 2;
            n_load_phase_delta = 1;
        else
            n_load_phase = 3;
            n_load_phase_delta = 3;
        end

        s_y_va = zeros(n_time_step,n_load_phase);
        s_d_va = zeros(n_time_step,n_load_phase_delta);
        y_y_siemens = zeros(n_time_step,n_load_phase);
        y_d_siemens = zeros(n_time_step,n_load_phase_delta);
        i_y_a = zeros(n_time_step,n_load_phase);
        i_d_a = zeros(n_time_step,n_load_phase_delta);

        if has_split_phase
            % Gridlab puts 12 loads in splitphases in field 3 of wye loads. We
            % see it rather as a delta load.
            s_y_va(i_time_step,:) = [data_table.S_y_1(i_load),data_table.S_y_2(i_load)];
            s_d_va(i_time_step,:) = data_table.S_y_3(i_load);
            y_y_siemens(i_time_step,:) = [data_table.Y_y_1(i_load),data_table.Y_y_2(i_load)];
            y_d_siemens(i_time_step,:) = data_table.Y_y_3(i_load);
            i_y_a(i_time_step,:) = [data_table.I_y_1(i_load),data_table.I_y_2(i_load)];
            i_d_a(i_time_step,:) = data_table.I_y_3(i_load);

        else
            s_y_va(i_time_step,:) = [data_table.S_y_1(i_load),data_table.S_y_2(i_load),data_table.S_y_3(i_load)];
            s_d_va(i_time_step,:) = [data_table.S_d_1(i_load),data_table.S_d_2(i_load),data_table.S_d_3(i_load)];
            y_y_siemens(i_time_step,:) = [data_table.Y_y_1(i_load),data_table.Y_y_2(i_load),data_table.Y_y_3(i_load)];
            y_d_siemens(i_time_step,:) = [data_table.Y_d_1(i_load),data_table.Y_d_2(i_load),data_table.Y_d_3(i_load)];
            i_y_a(i_time_step,:) = [data_table.I_y_1(i_load),data_table.I_y_2(i_load),data_table.I_y_3(i_load)];
            i_d_a(i_time_step,:) = [data_table.I_d_1(i_load),data_table.I_d_2(i_load),data_table.I_d_3(i_load)];
        end

        % Replace with empty if all loads are zero
        if all(s_y_va(:) == 0)
            s_y_va = [];
        end

        if all(s_d_va(:) == 0)
            s_d_va = [];
        end

        if all(y_y_siemens(:) == 0)
            y_y_siemens = [];
        end

        if all(y_d_siemens(:) == 0)
            y_d_siemens = [];
        end

        if all(i_y_a(:) == 0)
            i_y_a = [];
        end

        if all(i_d_a(:) == 0)
            i_d_a = [];
        end

        % If all loads are empty, do not create an uot.LoadZipSpec
        load_is_not_empty_array = ~[
            isempty(s_y_va), isempty(s_d_va);
            isempty(y_y_siemens), isempty(y_d_siemens);
            isempty(i_y_a), isempty(i_d_a);
            ];

        if any(load_is_not_empty_array(:))
            load_zip_spec_cell{i_load} = uot.LoadZipSpec(bus_name,...
                's_y_va',s_y_va,'s_d_va',s_d_va,...
                'y_y_siemens',y_y_siemens,'y_d_siemens',y_d_siemens,....
                'i_y_a',i_y_a,'i_d_a',i_d_a);
        end
    end
end

load_zip_spec_array = vertcat(load_zip_spec_cell{:});
end
