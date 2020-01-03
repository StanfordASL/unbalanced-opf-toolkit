function decision_variables = DefineDecisionVariables(opf_problem)
% |static|
decision_variables = DefineDecisionVariables@uot.PowerFlowSurrogate_Gan2014(opf_problem);

network = opf_problem.network;
n_time_step = opf_problem.n_time_step;

% We conserve this in decision_variables for compatibility with SDP
% formulation. In LP we put here the fixed link currents. See SetConstantLinkCurrents
decision_variables.L_link_cell = [];

gamma_mat = uot.PowerFlowSurrogate_Gan2014_LP.GetGammaMatrix();

n_phase_from_in_link = network.n_phase_from_in_link;

M = repmat(n_phase_from_in_link(:),1,n_time_step);
N = ones(size(M));

Lambda_link_cell = uot.SdpvarCell(M,N,'full','complex');

decision_variables.S_link_cell = cell(network.n_link,n_time_step);

for i_link = 1:network.n_link
    for i_time_step = 1:n_time_step
        link_phase = network.link_data_array(i_link).phase_from;

        gamma_link = gamma_mat(link_phase,link_phase);

        Lambda_link = Lambda_link_cell{i_link,i_time_step};

        decision_variables.S_link_cell{i_link,i_time_step} = gamma_link*diag(Lambda_link);
    end
end
end