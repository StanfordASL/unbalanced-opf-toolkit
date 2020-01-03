% This function is static
function [S_d_va,Y_y_siemens,Y_d_siemens,I_y_a,I_d_a] = BuildZIPloadMatrices(spec,network,bus_has_load_phase,bus_has_delta_load_phase)
% BuildLoadMatrices Consolidates the loads into matrices that are consistent with the bus numbering in network
%   [S_d_va,Y_y_siemens,Y_d_siemens,I_y_a,I_d_a] = BuildZIPloadMatrices(network,spec)
%   network is an instance of uot.Network
%   spec is an array of uot.LoadCaseZIPspec
%
%   Y_y_siemens and I_y_a are the matrices of wye-connected constant
%   power, constant admittance and constant current loads.
%   All are of dimension [n_bus,n_phase,n_time_step].
%   S_d_va, Y_d_siemens and I_d_a are the matrices of delta-connected constant
%   power, constant admittance and constant current loads.
%   All are of dimension [n_bus,n_phase_delta,n_time_step].

n_time_step = spec.n_time_step;
load_spec_array = spec.load_spec_array;

n_phase_delta = size(bus_has_delta_load_phase,2);

S_d_va = zeros(network.n_bus,n_phase_delta,n_time_step);
Y_y_siemens = zeros(network.n_bus,network.n_phase,n_time_step);
Y_d_siemens = zeros(network.n_bus,n_phase_delta,n_time_step);
I_y_a = zeros(network.n_bus,network.n_phase,n_time_step);
I_d_a = zeros(network.n_bus,n_phase_delta,n_time_step);

n_load_spec_array = numel(load_spec_array);

% Shortcuts for clarity
VerifyLoadPhases = @uot.AbstractLoadCase.VerifyLoadPhases;
ExtractLoadVector = @uot.AbstractLoadCase.ExtractLoadVector;

for i_load_spec_array = 1:n_load_spec_array
    load_spec = load_spec_array(i_load_spec_array);

    % Elementary loads
    s_d_va = load_spec.s_d_va;
    y_y_siemens = load_spec.y_y_siemens;
    y_d_siemens = load_spec.y_d_siemens;
    i_y_a = load_spec.i_y_a;
    i_d_a = load_spec.i_d_a;

    % Derived loads
    y_y_va = load_spec.y_y_va;
    y_d_va = load_spec.y_d_va;
    i_y_va = load_spec.i_y_va;
    i_d_va = load_spec.i_d_va;

    bus_name = load_spec.bus;

    bus_number = network.GetBusNumber(bus_name);

    assert(bus_number ~= 1, 'PCC cannot have any loads.')

    phase = bus_has_load_phase(bus_number,:);
    phase_delta = bus_has_delta_load_phase(bus_number,:);

    phase_primary = network.phase_primary;
    phase_primary_delta = phase_primary;

    load_phase = phase(phase_primary);
    load_phase_delta = phase_delta(phase_primary_delta);

    if isa(network,'uot.Network_Splitphased')
        phase_secondary = logical([0,0,0,1,1]);
        phase_secondary_delta = logical([0,0,0,1]);

        if network.bus_has_split_phase(bus_number)
            load_phase = phase(phase_secondary);
            load_phase_delta = phase_delta(phase_secondary_delta);
        end
    end

    VerifyLoadPhases(s_d_va,load_phase_delta,bus_name,n_time_step)
    VerifyLoadPhases(y_y_siemens,load_phase,bus_name,n_time_step)
    VerifyLoadPhases(y_d_siemens,load_phase_delta,bus_name,n_time_step)
    VerifyLoadPhases(i_y_a,load_phase,bus_name,n_time_step)
    VerifyLoadPhases(i_d_a,load_phase_delta,bus_name,n_time_step)

    VerifyLoadPhases(y_y_va,load_phase,bus_name,n_time_step)
    VerifyLoadPhases(y_d_va,load_phase_delta,bus_name,n_time_step)
    VerifyLoadPhases(i_y_va,load_phase,bus_name,n_time_step)
    VerifyLoadPhases(i_d_va,load_phase_delta,bus_name,n_time_step)

    S_d_va(bus_number,:,:) = S_d_va(bus_number,:,:) + ExtractLoadVector(s_d_va,phase_delta,load_phase_delta,n_time_step);
    Y_y_siemens(bus_number,:,:) = Y_y_siemens(bus_number,:,:) + ExtractLoadVector(y_y_siemens,phase,load_phase,n_time_step);
    Y_d_siemens(bus_number,:,:) = Y_d_siemens(bus_number,:,:) + ExtractLoadVector(y_d_siemens,phase_delta,load_phase_delta,n_time_step);
    I_y_a(bus_number,:,:) = I_y_a(bus_number,:,:) + ExtractLoadVector(i_y_a,phase,load_phase,n_time_step);
    I_d_a(bus_number,:,:) = I_d_a(bus_number,:,:) + ExtractLoadVector(i_d_a,phase_delta,load_phase_delta,n_time_step);

    % Derived loads
    u_nom_v = network.bus_data_array(bus_number).spec.u_nom_v;
    u_nom_delta_v = sqrt(3)*u_nom_v;

    y_y_va_ex = ExtractLoadVector(y_y_va,phase,load_phase,n_time_step);
    y_d_va_ex = ExtractLoadVector(y_d_va,phase_delta,load_phase_delta,n_time_step);

    Y_y_siemens(bus_number,:,:) = Y_y_siemens(bus_number,:,:) + conj(y_y_va_ex/u_nom_v.^2);
    Y_d_siemens(bus_number,:,:) = Y_d_siemens(bus_number,:,:) + conj(y_d_va_ex/u_nom_delta_v.^2);

    % Pre-rotate currents from derived loads if necessary
    % Recall that loads on split-phased buses are not changed due to pre-rotation
    if spec.current_is_prerotated && (isa('network','uot.Network_Splitphased') && ~network.bus_has_split_phase(bus_number))
        v_flat = network.GetFlatVoltage();
        v_base_v = u_nom_v*v_flat;

        v_base_expanded_v = repmat(v_base_v,n_time_step,1);

        delta_mat = uot.Delta();
        v_base_d_v = (delta_mat*v_base_v.').';

        v_base_d_expanded_v = repmat(v_base_d_v,n_time_step,1);

        if ~isempty(i_y_va)
            i_y_derived_a = conj(i_y_va./v_base_expanded_v);
        else
            i_y_derived_a = [];
        end

        if ~isempty(i_d_va)
            i_d_derived_a = conj(i_d_va./v_base_d_expanded_v);
        else
            i_d_derived_a = [];
        end

    else
        if ~isempty(i_y_va)
            i_y_derived_a = conj(i_y_va/u_nom_v);
        else
            i_y_derived_a = [];
        end

        if ~isempty(i_d_va)
            i_d_derived_a = conj(i_d_va/u_nom_delta_v);
        else
            i_d_derived_a = [];
        end
    end

    I_y_a(bus_number,:,:) = I_y_a(bus_number,:,:) + ExtractLoadVector(i_y_derived_a,phase,load_phase,n_time_step);
    I_d_a(bus_number,:,:) = I_d_a(bus_number,:,:) + ExtractLoadVector(i_d_derived_a,phase_delta,load_phase_delta,n_time_step);
end


% Verify that we did not add any loads where they should not exist
bus_has_load_phase_expanded = repmat(bus_has_load_phase,1,1,n_time_step);
bus_has_delta_load_phase_expanded = repmat(bus_has_delta_load_phase,1,1,n_time_step);

uot.AssertThatMissingPhasesAreZero(S_d_va,bus_has_delta_load_phase_expanded)
uot.AssertThatMissingPhasesAreZero(Y_y_siemens,bus_has_load_phase_expanded)
uot.AssertThatMissingPhasesAreZero(Y_d_siemens,bus_has_delta_load_phase_expanded)
uot.AssertThatMissingPhasesAreZero(I_y_a,bus_has_load_phase_expanded)
uot.AssertThatMissingPhasesAreZero(I_d_a,bus_has_delta_load_phase_expanded)
end












