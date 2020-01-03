% Based on algorithm 2
function [V_array,I_link_array] = RecoverVI(obj)
network = obj.opf_problem.network;
n_time_step = obj.opf_problem.n_time_step;

V_array = uot.ComplexNan(network.n_bus,network.n_phase,n_time_step);
I_link_array = uot.ComplexNan(network.n_link,network.n_phase,n_time_step);

M_eigenvalue_ratio = nan(network.n_link,n_time_step);

for i_time_step = 1:n_time_step
    V_array(1,:,i_time_step) = obj.opf_problem.spec.pcc_voltage_spec.v_pcc_array(i_time_step,:);
end

pcc_bus = 1;
link_matrix = dfsearch(network.connectivity_graph,pcc_bus,'edgetonew');

% Sanity check that we are not forgetting any links
assert(size(link_matrix,1) == network.n_link);

for i_link_dfs = 1:network.n_link
    source = link_matrix(i_link_dfs,1);
    sink = link_matrix(i_link_dfs,2);

    link = network.GetLinkNumber(source,sink);

    link_phase = network.link_data_array(link).phase_from;

    source_phase = network.bus_data_array(source).phase;

    phase_match = link_phase(source_phase);

    for i_time_step = 1:n_time_step
        V_source = V_array(source,link_phase,i_time_step);

        V_bus_source_diag = value(diag(obj.decision_variables.V_bus_cell{source,i_time_step}));

        S_link = value(obj.decision_variables.S_link_cell{link,i_time_step});

        I_link_array(link,link_phase,i_time_step) = S_link'*V_source(:)/sum(V_bus_source_diag(phase_match));

        Z_link = network.link_data_array(link).Z_from;

        V_array(sink,link_phase,i_time_step) = V_source(:) - Z_link*I_link_array(link,link_phase,i_time_step).';

        M_eigenvalue_ratio(link,i_time_step) = obj.ComputeEigenValueRatio(link,i_time_step);
    end
end

% Check that we did not miss anything
uot.AssertPhaseConsistency(V_array,network.bus_has_phase);
uot.AssertPhaseConsistency(I_link_array,network.link_has_phase_from);

M_eigenvalue_ratio_max = max(M_eigenvalue_ratio(:));

if M_eigenvalue_ratio_max >= obj.M_eigenvalue_ratio_tol
    warning('Max M eigenvalue ratio = %d is too high, solution is inaccurate.',M_eigenvalue_ratio_max);
end

obj.M_eigenvalue_ratio_max = M_eigenvalue_ratio_max;
end