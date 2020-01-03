function [I_link_from_ref_array,I_link_to_ref_array,I_link_from_ref_array_a,I_link_to_ref_array_a] = ParseLinkCurrentData(obj)
% Reads link current data Gridlabd and places them in arrays

file_name = obj.spec.PrependUOToutputDirFull(obj.spec.file_name_link_current_data);

[time_stamp_array,data_table_cell] = uot.ModelImporter_Gridlabd.ParseTimeSeriesData(file_name);
obj.ValidateTimeStampArray(time_stamp_array);

I_link_from_ref_array_a = zeros(obj.network.n_link,obj.network.n_phase,obj.spec.n_time_step);
I_link_to_ref_array_a = zeros(obj.network.n_link,obj.network.n_phase,obj.spec.n_time_step);

phase_primary = obj.network.phase_primary;

for i_time_step = 1:obj.spec.n_time_step
    data_table = data_table_cell{i_time_step};

    for i_row = 1:size(data_table,1)
        link_name = data_table.Name{i_row};

        link_number = obj.network.GetLinkNumber(link_name);

        % In some cases there will not be a link named link_name in the network.
        % This is because we remove useless links like open switches in
        % ParseLinkData. However, Gridlabd will still report currents for them.
        % However, these currents should be zero.
        if ~isnan(link_number)
            from_i = obj.network.link_data_array(link_number).from_i;

            i_link_from_ref_a = zeros(1,obj.network.n_phase);

            if isa(obj.network,'uot.Network_Splitphased') && obj.network.bus_has_split_phase(from_i)
                % Gridlabd makes a convention of flipping the signs of currents
                % in phase 2 of split-phase. Here, we do not. See also ParseLinkData.

                i_link_from_ref_a(obj.network.phase_secondary) = [data_table.current_in_1(i_row),-data_table.current_in_2(i_row)];
            else
                i_link_from_ref_a(phase_primary) = [data_table.current_in_1(i_row),data_table.current_in_2(i_row),data_table.current_in_3(i_row)];
            end

            to_i = obj.network.link_data_array(link_number).to_i;
            i_link_to_ref_a = zeros(1,obj.network.n_phase);

            % Gridlab uses flipped signs here, so we negate them.
            if isa(obj.network,'uot.Network_Splitphased') && obj.network.bus_has_split_phase(to_i)
                % Gridlabd makes a convention of flipping the signs of currents
                % in phase 2 of split-phase. Here, we do not. See also ParseLinkData.
                i_link_to_ref_a(obj.network.phase_secondary) = -[data_table.current_out_1(i_row),-data_table.current_out_2(i_row)];
            else
                i_link_to_ref_a(phase_primary) = -[data_table.current_out_1(i_row),data_table.current_out_2(i_row),data_table.current_out_3(i_row)];
            end

            I_link_from_ref_array_a(link_number,:,i_time_step) = i_link_from_ref_a;
            I_link_to_ref_array_a(link_number,:,i_time_step) = i_link_to_ref_a;
        else
            assert(all([data_table.current_in_1(i_row),data_table.current_in_2(i_row),data_table.current_in_3(i_row)]) == 0,'Discarded link has non-zero current in.')
            assert(all([data_table.current_out_1(i_row),data_table.current_out_2(i_row),data_table.current_out_3(i_row)]) == 0,'Discarded link has non-zero current out.')
        end
    end
end

% Note: Gridlabd sets all missing phases to zero
uot.AssertThatMissingPhasesAreZero(I_link_from_ref_array_a,obj.network.link_has_phase_from);
uot.AssertThatMissingPhasesAreZero(I_link_to_ref_array_a,obj.network.link_has_phase_to);

% Set missing phases to nan
link_has_phase_from_expanded = uot.ExpandBound(I_link_from_ref_array_a,obj.network.link_has_phase_from);
I_link_from_ref_array_a(~link_has_phase_from_expanded) = uot.ComplexNan();

link_has_phase_to_expanded = uot.ExpandBound(I_link_from_ref_array_a,obj.network.link_has_phase_to);
I_link_to_ref_array_a(~link_has_phase_to_expanded) = uot.ComplexNan();

% Note that there is a difference between this approach and the one in ParseVoltageData.
% In ParseVoltageData we set to nan whenever voltage is zero and then AssertPhaseConsistency.
% Here, we AssertThatMissingPhasesAreZero and then set to nan where appropriate.
% The reason for this is that voltage magnitude cannot be zero unless the bus
% is disconnected (which is not allowed by uot.Network). In contrast,
% zero current can happen whenever there are no loads downstream.
% Thus, setting zero currents to nan introduces fake missing phases.

I_link_from_ref_array = I_link_from_ref_array_a./obj.network.I_base_link_from_a;
I_link_to_ref_array = I_link_to_ref_array_a./obj.network.I_base_link_to_a;
end