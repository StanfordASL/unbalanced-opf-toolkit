function decision_variables = DefineDecisionVariables(opf_problem)
decision_variables = DefineDecisionVariables@uot.PowerFlowSurrogate_Gan2014(opf_problem);

network = opf_problem.network;
n_time_step = opf_problem.n_time_step;

M = repmat(network.n_phase_from_in_link(:),1,n_time_step);

decision_variables.S_link_cell = uot.SdpvarCell(M,M,'full','complex');
decision_variables.L_link_cell = uot.SdpvarCell(M,M,'hermitian','complex');
end