function opf_problem = CreateOPFproblem_Bolognani2015_LP(opf_problem_pre)
opf_spec = opf_problem_pre.spec;

opf_spec.pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Bolognani2015_LP();

opf_problem = uot.OPFproblem(opf_spec,opf_problem_pre.load_case);
opf_problem.sdpsettings = sdpsettings('solver','gurobi');
opf_problem.linearize_magnitude_constraints = true;
end