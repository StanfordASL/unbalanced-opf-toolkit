function tests = PowerFlowSurrogate_Gan2014_LPtest
% PowerFlowSurrogate_Gan2014_SDPtest Verifies that PowerFlowSurrogate_Gan2014_LPtest
% - Satisfies constraints
% - Matches the results from PowerFlowSurrogate_Gan2014_LP.SolveApproximatePowerFlowAlt
%   - This is gives us confidence that it is correct since the implementation
%   of the optimization and the approximate power flow solver are different
% - Sets constant link currents as expected

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


function TestPowerFlowSurrogate_Gan2014_LP(test_case)
opf_problem_pre_array = GetOPFproblemCatalogue();

for opf_problem_pre = opf_problem_pre_array(:).'
    opf_problem = CreateOPFproblem_Gan2014_LP(opf_problem_pre);
    SolutionFulfillsLinearPowerFlowAndConstraints(test_case,opf_problem);
    ConstantLinkCurrentMatchesSDP(test_case,opf_problem)
end
end

function SolutionFulfillsLinearPowerFlowAndConstraints(test_case,opf_problem)

% This sets the line currents to zero. It is necessary so that the results
% match those of SolveLinearizedPFwithControllableLoadValues
opf_problem.pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.FlatVoltage;

opf_problem.ValidateSpec();

[objective_value,solver_time,diagnostics] = opf_problem.Solve();

% Verify that optimization results match those from approximate power flow
U_array = opf_problem.GetVoltageEstimate();

[p_pcc_array,q_pcc_array] = opf_problem.EvaluatePowerInjectionFromPCCload();

load_case = opf_problem.CreateLoadCaseIncludingControllableLoadValues();
u_pcc_array = opf_problem.u_pcc_array;
t_pcc_array = opf_problem.t_pcc_array;
[U_array_ref,~,p_pcc_array_ref,q_pcc_array_ref] = uot.PowerFlowSurrogate_Gan2014_LP.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array);

verifyEqual(test_case,U_array,U_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)

s_pcc_array = p_pcc_array + 1i*q_pcc_array;
s_pcc_array_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;
verifyEqual(test_case,s_pcc_array,s_pcc_array_ref,'AbsTol',test_case.TestData.abs_tol_equality_s_pcc)

% Verify constraint satisfaction
opf_problem.AssertConstraintSatisfaction();
end

function ConstantLinkCurrentMatchesSDP(test_case,opf_problem_pre)
% This test verifies that constant link currents in PowerFlowSurrogate_Gan2014_LP
% match those from PowerFlowSurrogate_Gan2014_SDP on the first time step. This
% makes sense because PowerFlowSurrogate_Gan2014_SDP is exact in this case
% and it contains the link currents which we want to approximate.
load_case = opf_problem_pre.load_case;
u_pcc_array = opf_problem_pre.u_pcc_array;
t_pcc_array = opf_problem_pre.t_pcc_array;

% First create a basic opf_problem_sdp using uot.PowerFlowSurrogate_Gan2014_SDP.SolveApproxPowerFlow
% This opf_problem has no controllable loads and so represents the base case.
[U_array_sdp,T_array_sdp,p_pcc_array_sdp,q_pcc_array_sdp,opf_problem_sdp] = uot.PowerFlowSurrogate_Gan2014_SDP.SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array);

% Verify exactness of SDP just to be sure
[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = opf_problem_sdp.SolvePFwithControllableLoadValues();

V_array_sdp = uot.PolarToComplex(U_array_sdp,T_array_sdp);
V_array_ref = uot.PolarToComplex(U_array_ref,T_array_ref);
verifyEqual(test_case,V_array_sdp,V_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)

s_pcc_array_sdp = p_pcc_array_sdp + 1i*q_pcc_array_sdp;
s_pcc_array_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;
verifyEqual(test_case,s_pcc_array_sdp,s_pcc_array_ref,'AbsTol',test_case.TestData.abs_tol_equality_s_pcc)

% Create an equivalent to opf_problem_sdp but using PowerFlowSurrogate_Gan2014_LP
opf_spec_lp = opf_problem_sdp.spec;
opf_spec_lp.pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_LP();

opf_problem_lp = uot.OPFproblem(opf_spec_lp,load_case);

% Set constant current option to PFbaseCaseFirstTimeStep. That is, the
% fixed link currents should be those from the base case (i.e., without
% controllable loads) in the first step.
opf_problem_lp.pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep;

opf_problem_lp.Solve();

% Compare values for link currents
decision_variables_val_sdp = opf_problem_sdp.pf_surrogate.EvaluateDecisionVariables();
decision_variables_val_lp = opf_problem_lp.pf_surrogate.EvaluateDecisionVariables();

L_link_lp_cell = decision_variables_val_lp.L_link_cell;

% Recall that we only use the link currents in the first time step of the base case
% according to how PFbaseCaseFirstTimeStep works.
L_link_lp_cell_ref = repmat(decision_variables_val_sdp.L_link_cell(:,1),1,load_case.spec.n_time_step);

% Here we use a very loose tolerance because L_link in the SDP do not exactly
% match what is computed from currents in ComputeConstantLinkCurrents. The
% relationship between L_link and currents is as in RecoverVI.
verifyEqual(test_case,L_link_lp_cell,L_link_lp_cell_ref,'AbsTol',1e-3)

% Useful for debugging:
% L_link_lp_cell_err = cellfun(@(x,x_ref) norm(x - x_ref,inf),L_link_lp_cell,L_link_lp_cell_ref);
end

















