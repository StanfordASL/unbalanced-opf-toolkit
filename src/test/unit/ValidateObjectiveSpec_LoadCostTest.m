function tests = ValidateObjectiveSpec_LoadCostTest
% aaBoilerplateTest Verifies that ValidateObjectiveSpec_LoadCost works
% as expected: checking that load_name is a valid controllable load and that
% cost_p and cost_q are consistent with the controllable load

% This enables us to run the test directly instead of only through runtests
call_stack = dbstack;

% Call stack has only one element if function was called directly
if ~any(contains({call_stack.name},'runtests'))
    this_file_name = mfilename();
    runtests(this_file_name)
end

tests = functiontests(localfunctions);
end

function setupOnce(test_case)
aaSetupPath
end

function TestLoadNameCheck(test_case)
opf_problem_pre = GetBasicOPFproblem();

opf_spec = opf_problem_pre.spec;
load_case = opf_problem_pre.load_case;

opf_spec.controllable_load_spec_array = uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1]);
opf_spec.objective_spec = uot.OPFobjectiveSpec_LoadCost(uot.LoadCostSpec('charger_632_2','cost_p',-1));

opf_problem = uot.OPFproblem(opf_spec,load_case);

% This should work
opf_problem.ValidateSpec();

% Create opf_spec with invalid name for controllable load
opf_spec_bad = opf_spec;
opf_spec_bad.objective_spec = uot.OPFobjectiveSpec_LoadCost(uot.LoadCostSpec('charger_632_2_bad','cost_p',-1));

opf_problem_bad = uot.OPFproblem(opf_spec_bad,load_case);

% This should throw an error
verifyError(test_case,@() opf_problem_bad.ValidateSpec(),'');
end


function TestLoadCostPQsize(test_case)
opf_problem_pre = GetBasicOPFproblem();

opf_spec = opf_problem_pre.spec;
load_case = opf_problem_pre.load_case;

opf_spec.controllable_load_spec_array = uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1]);
opf_spec.objective_spec = uot.OPFobjectiveSpec_LoadCost(uot.LoadCostSpec('charger_632_2','cost_p',-1,'cost_q',1));

opf_problem = uot.OPFproblem(opf_spec,load_case);

% This should work
opf_problem.ValidateSpec();

% Create opf_spec with invalid size for cost_p
opf_spec_bad_p = opf_spec;
opf_spec_bad_p.objective_spec = uot.OPFobjectiveSpec_LoadCost(uot.LoadCostSpec('charger_632_2','cost_p',-[1,1],'cost_q',1));

opf_problem_bad_p = uot.OPFproblem(opf_spec_bad_p,load_case);

% This should throw an error
verifyError(test_case,@() opf_problem_bad_p.ValidateSpec(),'');

% Create opf_spec with invalid size for cost_q
opf_spec_bad_q = opf_spec;
opf_spec_bad_q.objective_spec = uot.OPFobjectiveSpec_LoadCost(uot.LoadCostSpec('charger_632_2','cost_q',-1,'cost_q',[1,1]));

opf_problem_bad_q = uot.OPFproblem(opf_spec_bad_q,load_case);

% This should throw an error
verifyError(test_case,@() opf_problem_bad_q.ValidateSpec(),'');
end