function tests = LoadCaseZIPtest
% Verifies that LoadCaseZIPtest works as expected
% Note: we do not test LoadCasePy explicitly because it is only a thin wrapper
% over AbstractLoadCase which is the base class of LoadCaseZIP.

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

test_case.TestData.rel_tol_equality = 1e-15;
end

function TestTimes(test_case)
load_case = GetLoadCaseIEEE_13_NoRegs_Manual();

% Scaling with a scalar
vec_1 = 0.5;
load_case_1 = load_case.*vec_1;

VerifyLoadCaseZIPscaling(test_case,load_case,vec_1,load_case_1)

% Scaling with a vector and extending number of time_steps
vec_2 = [0.7,1.2,1.5];
load_case_2 = load_case.*vec_2;

% Verify extension of number of time steps
verifyEqual(test_case,load_case_2.spec.n_time_step,numel(vec_2))
VerifyLoadCaseZIPscaling(test_case,load_case,vec_2,load_case_2)

% Scale with a vector again but without changing number of time steps
load_case_3 = load_case_2.*vec_2;

verifyEqual(test_case,load_case_3.spec.n_time_step,numel(vec_2))
VerifyLoadCaseZIPscaling(test_case,load_case_2,vec_2,load_case_3)
end

function VerifyLoadCaseZIPscaling(test_case,load_case,vec,load_case_scaled)
% Permute vec to be a vector along dimension 3
vec_3 = permute(vec(:),[3,2,1]);

S_y_ref_va = load_case.S_y_va.*vec_3;
S_d_ref_va = load_case.S_d_va.*vec_3;

Y_y_siemens_ref_va = load_case.Y_y_siemens.*vec_3;
Y_d_siemens_ref_va = load_case.Y_d_siemens.*vec_3;

I_y_a_ref_va = load_case.I_y_a.*vec_3;
I_d_a_ref_va = load_case.I_d_a.*vec_3;

verifyEqual(test_case,load_case_scaled.S_y_va,S_y_ref_va,'RelTol',test_case.TestData.rel_tol_equality)
verifyEqual(test_case,load_case_scaled.S_d_va,S_d_ref_va,'RelTol',test_case.TestData.rel_tol_equality)

verifyEqual(test_case,load_case_scaled.Y_y_siemens,Y_y_siemens_ref_va,'RelTol',test_case.TestData.rel_tol_equality)
verifyEqual(test_case,load_case_scaled.Y_d_siemens,Y_d_siemens_ref_va,'RelTol',test_case.TestData.rel_tol_equality)

verifyEqual(test_case,load_case_scaled.I_y_a,I_y_a_ref_va,'RelTol',test_case.TestData.rel_tol_equality)
verifyEqual(test_case,load_case_scaled.I_d_a,I_d_a_ref_va,'RelTol',test_case.TestData.rel_tol_equality)
end