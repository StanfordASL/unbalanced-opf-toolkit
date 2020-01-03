function decision_variables = DefineDecisionVariables(opf_problem)
% |static|, |private|

network = opf_problem.network;
n_time_step = opf_problem.n_time_step;

n_phase_in_bus = network.n_phase_in_bus;

M = repmat(n_phase_in_bus(:),1,n_time_step);

decision_variables.V_bus_cell = uot.SdpvarCell(M,M,'hermitian','complex');
end