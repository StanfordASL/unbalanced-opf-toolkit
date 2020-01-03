function U_array = ComputeVoltageMangitudeEstimate(obj)
% Estimate voltage magnitude from the square root of the diagonals of V_bus_cell
% Note for SDP: the mangitudes computed this way match those from uot.PowerFlowSurrogate_Gan2014_SDP.RecoverVI
% however that method also estimates phase. This is probably faster

opf_problem = obj.opf_problem;
network = opf_problem.network;

n_time_step = opf_problem.n_time_step;

U_array = nan(network.n_bus,network.n_phase,n_time_step);

for i_time_step = 1:n_time_step
    for i_bus = 1:network.n_bus
        V_bus_val = value(obj.decision_variables.V_bus_cell{i_bus,i_time_step});

        U_bus_sq = diag(V_bus_val);

        bus_phase = network.bus_has_phase(i_bus,:);

        U_array(i_bus,bus_phase,i_time_step) = sqrt(U_bus_sq);
    end
end

% Verify that we did not miss anything
uot.AssertPhaseConsistency(U_array,network.bus_has_phase);
end