% This function is static
function S_y_va = BuildPyLoadMatrix(spec,network,bus_has_load_phase)
n_time_step = spec.n_time_step;
load_spec_array = spec.load_spec_array;

S_y_va = zeros(network.n_bus,network.n_phase,n_time_step);

n_load_spec_array = numel(load_spec_array);

% Shortcuts for clarity
VerifyLoadPhases = @uot.AbstractLoadCase.VerifyLoadPhases;
ExtractLoadVector = @uot.AbstractLoadCase.ExtractLoadVector;

for i_load_spec_array = 1:n_load_spec_array
    load_spec = load_spec_array(i_load_spec_array);

    s_y_va = load_spec.s_y_va;

    bus_name = load_spec.bus;

    bus_number = network.GetBusNumber(bus_name);

    assert(bus_number ~= 1, 'PCC cannot have any loads.')

    phase = bus_has_load_phase(bus_number,:);

    phase_primary = network.phase_primary;

    if isa(network,'uot.Network_Unbalanced')
        load_phase = phase(phase_primary);
    else
        phase_secondary = logical([0,0,0,1,1]);

        if network.bus_has_split_phase(bus_number)
            load_phase = phase(phase_secondary);
        else
            load_phase = phase(phase_primary);
        end
    end

    VerifyLoadPhases(s_y_va,load_phase,bus_name,n_time_step)

    S_y_va(bus_number,:,:) = S_y_va(bus_number,:,:) + ExtractLoadVector(s_y_va,phase,load_phase,n_time_step);
end

% Verify that we did not add any loads where they should not exist
bus_has_load_expanded = repmat(network.bus_has_load,1,1,n_time_step);
uot.AssertThatMissingPhasesAreZero(S_y_va,bus_has_load_expanded)
end