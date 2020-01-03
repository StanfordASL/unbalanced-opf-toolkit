function opf_problem = CreateOPFproblem_Gan2014_LP(opf_problem_pre)
opf_spec = opf_problem_pre.spec;

opf_spec.pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_LP();

opf_problem = uot.OPFproblem(opf_spec,opf_problem_pre.load_case);
opf_problem.sdpsettings = sdpsettings('solver','sedumi');
opf_problem.linearize_magnitude_constraints = true;
end
