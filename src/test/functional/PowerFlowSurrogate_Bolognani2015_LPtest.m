function tests = PowerFlowSurrogate_Bolognani2015_LPtest
% Verifies that PowerFlowSurrogate_Bolognani2015_LP:
% - Satisfies constraints
% - Matches the results from PowerFlowSurrogate_Bolognani2015_LP.SolveApproximatePowerFlowAlt
%   - This gives us confidence that it is correct since the implementation
%   of the optimization and the approximate power flow solver are different
%   - PowerFlowSurrogate_Bolognani2015_LP.SolveApproximatePowerFlowAlt matches
%   the original implementation from Bolognani

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
% Code from Bolognani's paper
addpath([GetPathToUOT(), 'third_party/1ACPF']);

test_case.TestData.abs_tol_equality = 5e-6;

test_case.TestData.abs_tol_equality_soft = 1e-5;
end

function TestPowerFlowSurrogate_Bolognani2015_LP(test_case)

opf_problem_pre_array = GetOPFproblemCatalogue();

for opf_problem_pre = opf_problem_pre_array(:).'
    opf_problem = CreateOPFproblem_Bolognani2015_LP(opf_problem_pre);

    % Test linearization at FlatVoltage
    opf_problem.pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.FlatVoltage;
    SolutionFulfillsLinearPowerFlowAndConstraints(test_case,opf_problem);

    % Test linearization at PFbaseCaseFirstTimeStep
    opf_problem.pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep;
    SolutionFulfillsLinearPowerFlowAndConstraints(test_case,opf_problem);

    % Test linearization at NoLoadFirstTimeStep
    opf_problem.pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.NoLoadFirstTimeStep;
    SolutionFulfillsLinearPowerFlowAndConstraints(test_case,opf_problem);
end
end

function SolutionFulfillsLinearPowerFlowAndConstraints(test_case,opf_problem)
opf_problem.ValidateSpec();

[objective_value,solver_time,diagnostics] = opf_problem.Solve();

% Verify that optimization results match those from approximate power flow
[U_array,T_array] = opf_problem.GetVoltageEstimate();

[p_pcc_array,q_pcc_array] = opf_problem.EvaluatePowerInjectionFromPCCload();

load_case = opf_problem.CreateLoadCaseIncludingControllableLoadValues();
u_pcc_array = opf_problem.u_pcc_array;
t_pcc_array = opf_problem.t_pcc_array;

[U_ast,T_ast] = opf_problem.pf_surrogate.GetLinearizationVoltage(opf_problem.pf_surrogate.linearization_point);

[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,U_ast,T_ast);

V_array = uot.PolarToComplex(U_array,T_array);
V_array_ref = uot.PolarToComplex(U_array_ref,T_array_ref);

V_array_delta = abs(V_array - V_array_ref);

verifyEqual(test_case,V_array,V_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)

s_pcc_array = p_pcc_array + 1i*q_pcc_array;
s_pcc_array_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;

s_pcc_array_delta = abs(s_pcc_array - s_pcc_array_ref);

verifyEqual(test_case,s_pcc_array,s_pcc_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)

% Verify constraint satisfaction
opf_problem.AssertConstraintSatisfaction();
end

function TestAgainstPaper(test_case)
% Get data from Bologani's original implementation. This code operates on a
% simplified IEEE 13 node feeder. The simplification consists in removing
% the regulator and replacing all loads with constant power wye-connected
% ones.

do_plots = false;
[U_lin_stack_ref, T_lin_stack_ref, P_inj_lin_stack_ref, Q_inj_lin_stack_ref] = example_ieee13(do_plots);
U_lin_ref_pre = uot.Unstack(U_lin_stack_ref);
T_lin_ref_pre = uot.Unstack(T_lin_stack_ref);

p_pcc_lin_ref = -P_inj_lin_stack_ref(1:3).';
q_pcc_lin_ref = -Q_inj_lin_stack_ref(1:3).';

s_pcc_lin_ref = p_pcc_lin_ref + 1i*q_pcc_lin_ref;

% Bus 1 in _lin_ref corresponds to bus n630, bus 2 to n632 and so on
lin_ref_bus_name_cell = {
    'n630';
    'n632';
    'n633';
    'l634';
    'l645';
    'l646';
    'l671';
    'l692';
    'l675';
    'n680';
    'n684';
    'l611';
    'l652';
    };

% Get data from UOT
% IEEE_13_Basic has the same simplifications made by Bolognani
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/IEEE_13_Basic'],'IEEE_13_Basic.glm');

% Same as in example_ieee13
model_importer_spec.s_base_va = 5e6;
model_importer_spec.time_step_s = 1;
model_importer_spec.n_time_step = 1;

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);

model_importer.Initialize();

load_case_pre = model_importer.load_case;
load_case = load_case_pre.ConvertToLoadCasePy();

network = load_case.network;

u_pcc = U_lin_ref_pre(1,:);
t_pcc = T_lin_ref_pre(1,:);

% Solve linearized power flow using flat voltage
[U_lin,T_lin,p_pcc_lin,q_pcc_lin] = uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt(load_case,u_pcc,t_pcc);
V_lin = uot.PolarToComplex(U_lin,T_lin);

bus_name_cell = network.bus_name_cell;

% Reorder V_lin_ref to math bus ordering
U_lin_ref = uot.PermuteNamedRows(U_lin_ref_pre,lin_ref_bus_name_cell,bus_name_cell);
T_lin_ref = uot.PermuteNamedRows(T_lin_ref_pre,lin_ref_bus_name_cell,bus_name_cell);
V_lin_ref = uot.PolarToComplex(U_lin_ref,T_lin_ref);

V_lin_delta = abs(V_lin - V_lin_ref);

s_pcc_lin = p_pcc_lin + 1i*q_pcc_lin;

% Since we are comparing to a different implementation, we use a relaxed
% tolerance
verifyEqual(test_case,V_lin,V_lin_ref,'AbsTol',test_case.TestData.abs_tol_equality_soft)
verifyEqual(test_case,s_pcc_lin,s_pcc_lin_ref,'AbsTol',test_case.TestData.abs_tol_equality_soft)
end