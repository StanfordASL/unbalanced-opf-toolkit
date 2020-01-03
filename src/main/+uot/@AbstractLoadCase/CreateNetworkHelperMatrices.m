function [bus_has_load_phase,bus_has_delta_load_phase,delta_network_matrix] = CreateNetworkHelperMatrices(network)
% |static| |private| Create matrices based on the network that are necessary for power flow computation
%
% Synopsis::
%
%   [bus_has_load_phase,bus_has_delta_load_phase,delta_network_matrix] = uot.AbstractLoadCase.CreateNetworkHelperMatrices(network);
%
% Description:
%   The power flow solver requires a series of helper arrays based on the network:
%
%   `bus_has_load_phase` represents where the network can have wye-connected
%   loads. It is very similar to `bus_has_phase` in |uot.AbstractNetwork|.
%   The one difference is that the entries representing the PCC are false
%   since there cannot be a load connected there.
%
%   `bus_has_delta_load_phase` has a similar structure but denotes where the
%   network can have delta-loads. Delta loads are ordered [ab bc ca].
%   For |uot.Network_SplitPhased| this matrix has a fourth column indicating split-phase
%   loads 12.
%
%  `delta_network_matrix` is used to compute the current injections from delta-
%   connected loads using an approach inspired by :cite:`Bernstein2017`.
%   For further details, see
%   :meth:`uot.LoadCaseZIP.GetCurrentFromZloads<+uot.@LoadCaseZIP.GetCurrentFromZloads>`,
%   :meth:`uot.LoadCaseZIP.GetCurrentFromIloads<+uot.@LoadCaseZIP.GetCurrentFromIloads>`,
%   :meth:`uot.LoadCaseZIP.GetCurrentFromPloads<+uot.@LoadCaseZIP.GetCurrentFromPloads>`
%
% Arguments:
%   network (|uot.AbstractNetwork|): Network on which the load case acts
%
% Returns:
%
%   - **bus_has_load_phase** (logical) - Array(n_bus,n_phase) representing where the network can have wye-connected loads
%   - **bus_has_delta_load_phase** (logical) - Array(n_bus,n_phase_delta) representing where the network can have delta-connected loads
%   - **delta_network_matrix** (logical) - Matrix to help compute the current injections from delta-connected loads
%

% .. Line with 80 characters for reference #####################################

validateattributes(network,{'uot.AbstractNetwork'},{'scalar'},mfilename,'network',1)

% All buses have load except pcc
bus_has_load_phase = network.bus_has_phase;
bus_has_load_phase(1,:) = false;

n_bus = size(bus_has_load_phase,1);

phase_primary = network.phase_primary;

if isa(network,'uot.Network_Unbalanced')
    n_phase_delta = 3;

elseif isa(network,'uot.Network_Splitphased')

    n_phase_delta = 4;

    phase_secondary = network.phase_secondary;
    phase_secondary_delta = 4;

else
    error('Invalid network class.');
end

bus_has_delta_load_phase = false(n_bus,n_phase_delta);

delta_bus_cell = cell(n_bus,1);

for i_bus = 1:n_bus
    bus_has_delta_load_phase(i_bus,phase_primary) = GetLoadPhaseDeltaPrimary(bus_has_load_phase(i_bus,phase_primary));

    delta_bus_cell{i_bus} = sparse(DeltaBusPrimary(bus_has_load_phase(i_bus,phase_primary)));

    if isa(network,'uot.Network_Splitphased') && network.bus_has_split_phase(i_bus)
        bus_has_delta_load_phase(i_bus,phase_secondary_delta) = GetLoadPhaseDeltaSecondary(bus_has_load_phase(i_bus,phase_secondary));

        delta_bus_cell{i_bus} = sparse(DeltaBusSecondary(bus_has_load_phase(i_bus,phase_secondary)));
    end
end

delta_network_matrix = blkdiag(delta_bus_cell{:});
end

function load_phase_delta_primary = GetLoadPhaseDeltaPrimary(load_phase_primary)
if all(load_phase_primary == [1,1,1])
    load_phase_delta_primary = [1,1,1];
elseif all(load_phase_primary == [1,1,0])
    load_phase_delta_primary = [1,0,0];
elseif all(load_phase_primary == [0,1,1])
    load_phase_delta_primary = [0,1,0];
elseif all(load_phase_primary == [1,0,1])
    load_phase_delta_primary = [0,0,1];
else
    load_phase_delta_primary = [0,0,0];
end

load_phase_delta_primary = logical(load_phase_delta_primary);
end

function load_phase_delta_secondary = GetLoadPhaseDeltaSecondary(load_phase_secondary)

if all(load_phase_secondary == [1,1])
    load_phase_delta_secondary = 1;
elseif all(load_phase_secondary == [0,0])
    load_phase_delta_secondary = 0;
else
    error('Invalid load_phase_secondary.');
end

load_phase_delta_secondary = logical(load_phase_delta_secondary);
end

% Based on Bernstein2017
function res = DeltaBusPrimary(load_phase_primary)
% Based on GLD OPF 21
if all(load_phase_primary == [1,1,1])
    res = uot.Delta();
elseif all(load_phase_primary == [1,1,0]) || all(load_phase_primary == [0,1,1])
    res = [1,-1];

elseif all(load_phase_primary == [1,0,1])
    res = [-1,1];

elseif sum(load_phase_primary) <= 1
    res = zeros(0,sum(load_phase_primary));
else
    error('Invalid load_phase')
end
end

function res = DeltaBusSecondary(load_phase_secondary)
if all(load_phase_secondary == [1,1])
    res = [1, 1];
else
    error('Invalid load_phase_secondary')
end
end

