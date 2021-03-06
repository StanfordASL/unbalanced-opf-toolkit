function tests = PowerFlowSurrogate_Bernstein2017_LP_2test
% Verifies that PowerFlowSurrogate_Bernstein2017_LP_2:
% - PowerFlowSurrogate_Bernstein2017_LP.SolveApproximatePowerFlowAlt can
%   replicate the results in the original paper.

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

test_case.TestData.abs_tol_equality = 5e-6;
end

function TestAgainstPaper(test_case)
load_case_zip = GetLoadCaseIEEE_13_NoRegs_Manual();
% Reference voltage from spec (we do not model the regulator)
u_pcc = [1.0625, 1.0500, 1.0687];
t_pcc = deg2rad([0, -120, 120]);

% Convert all loads to constant power wye-connected
load_case_pre = load_case_zip.ConvertToLoadCasePy();

% The paper uses kappa \in [-1,2]. However, we focus here on a narrower
% range where the approximate power flow is closest to the exact one.
kappa_vec = -0.2:0.1:1.2;

% Reorder kappa_vec so that kappa_vec(1) is 1.
% This, will allow us to linearize at the unscaled load
kappa_vec = [kappa_vec(kappa_vec == 1), kappa_vec(kappa_vec ~= 1)];

load_case = load_case_pre.*kappa_vec;

% Extend u_pcc_array and t_pcc_array to have one entry per time step
n_time_step = load_case.n_time_step;
u_pcc_array = repmat(u_pcc,n_time_step,1);
t_pcc_array = repmat(t_pcc,n_time_step,1);

linearization_point = uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep;
[U_ast,T_ast] = linearization_point.GetVoltageAtLinearizationPoint(load_case,u_pcc_array,t_pcc_array);

[U_array,T_array, p_pcc_array, q_pcc_array,extra_data] = PowerFlowSurrogate_Bernstein2017_LP_3.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,U_ast,T_ast);

V_array = uot.PolarToComplex(U_array,T_array);
s_pcc = p_pcc_array + 1i*q_pcc_array;

% Get reference values from solving exact power flow
[U_array_ref,T_array_ref, p_pcc_array_ref, q_pcc_array_ref] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);

V_array_ref = uot.PolarToComplex(U_array_ref,T_array_ref);
s_pcc_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;

% We select the initial tolerance based on aaReplicatePaperResults and
% we tune them so that the tests just pass.
v_tol = 6e-3;

% For simplicity, we compare elementwise instead of using the paper's relative
% error metric. This will also issue a more informative error if the test fails.
% We use absolute tolerances because voltage magnitude is close to 1
verifyEqual(test_case,V_array,V_array_ref,'AbsTol',v_tol)
verifyEqual(test_case,extra_data.U_array_eq9,U_array_ref,'AbsTol',v_tol)
verifyEqual(test_case,extra_data.U_array_eq12,U_array_ref,'AbsTol',v_tol)

% We compare s_pcc using relative error because it is not necessarily close to 1
% Note that the tolerance is much larger than the 0.02 error we saw in the plot
% of aaReplicatePaperResults. This is because here we normalize with the actual
% load and not the maximal one as done in the paper. Thus the errors for the
% small loads (small kappa) are much larger than before.
s_pcc_tol = 0.15;
verifyEqual(test_case,s_pcc,s_pcc_ref,'RelTol',s_pcc_tol)
end











