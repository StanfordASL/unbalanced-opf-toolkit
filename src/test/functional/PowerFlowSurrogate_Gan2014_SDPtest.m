function tests = PowerFlowSurrogate_Gan2014_SDPtest
% PowerFlowSurrogate_Gan2014_SDPtest Verifies that PowerFlowSurrogate_Gan2014_SDP
% - Satisfies constraints
% - Is exact for a given case
% - Link currents fulfill our definition

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

test_case.TestData.abs_tol_equality = 2e-6;
% Here we use a looser tolerance, since this is more dificult to get right
test_case.TestData.abs_tol_equality_s_pcc = 5e-5;
end

function TestPowerFlowSurrogate_Gan2014_SDP(test_case)

opf_problem_pre_array = GetOPFproblemCatalogue();

for opf_problem_pre = opf_problem_pre_array(:).'
    opf_problem = CreateOPFproblem_Gan2014_SDP(opf_problem_pre);
    HelperTestSolveApproximatePowerFlow(test_case,opf_problem);
    HelperTestPowerFlowSurrogate_Gan2014_SDP(test_case,opf_problem);
end

end

function HelperTestSolveApproximatePowerFlow(test_case,opf_problem)
% Verify that uot.PowerFlowSurrogateSpec_Gan2014_SDP.SolveApproximatePowerFlow
% is exact

load_case = opf_problem.load_case;
u_pcc_array = opf_problem.u_pcc_array;
t_pcc_array = opf_problem.t_pcc_array;

[U_array,T_array,p_pcc_array,q_pcc_array] = uot.PowerFlowSurrogate_Gan2014_SDP.SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array);

[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);

V_array = uot.PolarToComplex(U_array,T_array);
V_array_ref = uot.PolarToComplex(U_array_ref,T_array_ref);

verifyEqual(test_case,V_array,V_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)

s_pcc_array = p_pcc_array + 1i*q_pcc_array;
s_pcc_array_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;

verifyEqual(test_case,s_pcc_array,s_pcc_array_ref,'AbsTol',test_case.TestData.abs_tol_equality_s_pcc)
end

function HelperTestPowerFlowSurrogate_Gan2014_SDP(test_case,opf_problem)
opf_problem.ValidateSpec();

[objective_value,solver_time,diagnostics] = opf_problem.Solve();

% Verify exactness
[U_array,T_array]= opf_problem.GetVoltageEstimate();

[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = opf_problem.SolvePFwithControllableLoadValues();

V_array = uot.PolarToComplex(U_array,T_array);
V_array_ref = uot.PolarToComplex(U_array_ref,T_array_ref);
verifyEqual(test_case,V_array,V_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)

[p_pcc_array,q_pcc_array] = opf_problem.EvaluatePowerInjectionFromPCCload();
s_pcc_array = p_pcc_array + 1i*q_pcc_array;
s_pcc_array_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;
verifyEqual(test_case,s_pcc_array,s_pcc_array_ref,'AbsTol',test_case.TestData.abs_tol_equality_s_pcc)

% Verify constraint satisfaction
opf_problem.AssertConstraintSatisfaction();

% Verify that link currents match our definition
network = opf_problem.network;
I_link_from_array_ref = network.ComputeLinkCurrentsAndPowers(U_array,T_array);

I_link_from_array = opf_problem.pf_surrogate.ComputeLinkCurrentEstimate();

verifyEqual(test_case,I_link_from_array,I_link_from_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)
end


