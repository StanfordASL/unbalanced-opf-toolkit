function decision_variables = DefineDecisionVariables(opf_problem)
network = opf_problem.network;
n_time_step = opf_problem.n_time_step;

n_bus_has_phase = network.n_bus_has_phase;

decision_variables.U_array_stack = sdpvar(n_bus_has_phase,n_time_step,'full');
decision_variables.T_array_stack = sdpvar(n_bus_has_phase,n_time_step,'full');
end