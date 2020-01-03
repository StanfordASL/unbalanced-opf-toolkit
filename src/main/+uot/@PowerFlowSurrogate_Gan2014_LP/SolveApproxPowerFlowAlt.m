function [U_array,T_array, p_pcc_array, q_pcc_array] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
% This function is static

% The implementation is based on the equations below (12) in Gan2014. It does
% not consider Y_shunt for the buses and assumes zero link currents.
% It does not estimate phase

% Note: this is useful for debugging. Results should match those from the optimization
% if Y_shunt are zero and link current is set to zero.
%
% Keywork arguments: Z_link_norm_min

validateattributes(load_case,{'uot.LoadCasePy'},{'scalar'},mfilename,'load_case',1);
load_case.ValidatePCCvoltage(u_pcc_array,t_pcc_array);

% See comment on Z_link_norm_min_default
p = inputParser;
addParameter(p,'Z_link_norm_min',uot.PowerFlowSurrogate_Gan2014.Z_link_norm_min_default);
parse(p,varargin{:});
Z_link_norm_min = p.Results.Z_link_norm_min;

network = load_case.network;
uot.PowerFlowSurrogate_Gan2014.WarnIfNetworkHasShunts(network);

% Note: this implementation is naive and could probably be made more
% efficient
downstream = cell(network.n_bus,1);
upstream = cell(network.n_bus,1);
for i_bus = 2:network.n_bus
    downstream{i_bus} = dfsearch(network.connectivity_graph,i_bus);
    upstream{i_bus} = shortestpath(network.connectivity_graph,1,i_bus);
end

% Loads are negative power injections
S_inj_array = -load_case.S_y;

% Injection at substation is unknown
S_inj_array(1,:,:) = nan;

s_pcc_array = -sum(S_inj_array(2:end,:,:),1,'omitnan');
% Adjust dimensions
s_pcc_array = uot.PermuteDims1and3(s_pcc_array);

p_pcc_array = real(s_pcc_array);
q_pcc_array = imag(s_pcc_array);

v_pcc_array = uot.PolarToComplex(u_pcc_array,t_pcc_array);

n_time_step = load_case.spec.n_time_step;

gamma_mat = uot.PowerFlowSurrogate_Gan2014_LP.GetGammaMatrix();

V_bus_cell = cell(network.n_bus,n_time_step);

U_array = nan(network.n_bus,network.n_phase,n_time_step);
T_array = [];

for i_time_step = 1:n_time_step
    S_link_cell = cell(network.n_link);

    for i_link = 1:network.n_link
        link_phase = network.link_has_phase_from(i_link,:);

        to_i = network.link_data_array(i_link).to_i;

        downstream_to_i = downstream{to_i};

        S_inj_downstream =  S_inj_array(downstream_to_i,:,i_time_step);

        Lambda_link_pre = -sum(S_inj_downstream,1,'omitnan');

        Lambda_link = Lambda_link_pre(link_phase);

        gamma_link = gamma_mat(link_phase,link_phase);

        S_link_cell{i_link} = gamma_link*diag(Lambda_link(:));
    end

    v_pcc =  v_pcc_array(i_time_step,:);

    V_bus_pcc = v_pcc(:)*v_pcc(:)';

    V_bus_cell{1,i_time_step} = V_bus_pcc;

    U_array(1,:,i_time_step) = abs(v_pcc);

    for i_bus = 2:network.n_bus
        bus_phase = network.bus_has_phase(i_bus,:);

        n_bus_phase = network.n_phase_in_bus(i_bus);

        V_bus_drop = zeros(n_bus_phase,n_bus_phase);

        upstream_bus = upstream{i_bus}(:).';

        upstream_link_mat = [upstream_bus(1:end-1);upstream_bus(2:end)];

        for upstream_link = upstream_link_mat
            link_number = network.GetLinkNumber(upstream_link(1),upstream_link(2));

            link_phase = network.link_has_phase_from(link_number,:);

            z_link_pre = network.link_data_array(link_number).Z_from;
            z_link = uot.PowerFlowSurrogate_Gan2014.AdjustZlink(z_link_pre, Z_link_norm_min);

            S_link = S_link_cell{link_number};

            voltage_drop_pre = S_link*z_link' + z_link*S_link';

            phase_match = bus_phase(link_phase);

            V_bus_drop = V_bus_drop + voltage_drop_pre(phase_match,phase_match);
        end

        V_bus = V_bus_pcc(bus_phase,bus_phase) - V_bus_drop;
        V_bus_cell{i_bus,i_time_step} = V_bus;

        U_bus = sqrt(diag(V_bus));

        % Remove numerical noise
        assert(norm(imag(U_bus)) < 1e-9)
        U_bus = real(U_bus);

        U_array(i_bus,bus_phase,i_time_step) = U_bus;
    end
end

% Verify that we did not miss anything
uot.AssertPhaseConsistency(U_array,network.bus_has_phase)
end