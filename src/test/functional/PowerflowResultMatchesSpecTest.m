function tests = PowerflowResultMatchesSpecTest
% PowerflowResultMatchesSpecTest verifies that uot power flow solver
% matches specification for tests networks

% We currently test for voltage and PCC load. We currently do not test for
% line currents against spec. However, we do it against Gridlab in
% PowerflowResultMatchesGridlabTest.


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

s_pcc_ieee_13_va = [1251.398 + 1i*681.570, 977.332 + 1i*373.418, 1348.461 + 1i*669.784]*1e3;
s_pcc_ieee_123_va = [1463.861 + 1i*582.101, 963.484 + 1i*343.687, 1193.153 + 1i*398.976]*1e3;

test_case.TestData.s_pcc_ieee_13_va = s_pcc_ieee_13_va;
test_case.TestData.s_pcc_ieee_123_va = s_pcc_ieee_123_va;

end

function TestPowerflowResultMatchesSpec_Gridlab(test_case)

model_importer_array = [
    GetModelImporterIEEE_13_NoRegs;
    GetModelImporterIEEE_13();
    GetModelImporterIEEE_123();
    ];

solution_file_name_cell = {
    'IEEE_13_NoRegs_Solution'
    'IEEE_13_Solution';
    'IEEE_123_Solution';
    };

s_pcc_ieee_13_va = test_case.TestData.s_pcc_ieee_13_va;
s_pcc_ieee_123_va = test_case.TestData.s_pcc_ieee_123_va ;

s_pcc_ref_va_cell = {
    s_pcc_ieee_13_va;
    s_pcc_ieee_13_va;
    s_pcc_ieee_123_va;
    };

abs_tol_array = [
    5e-4;
    5e-4;
    5e-3;
    ];

n_model = numel(model_importer_array);

for i_model = 1:n_model
    model_importer = model_importer_array(i_model);
    solution_file_name = solution_file_name_cell{i_model};
    abs_tol = abs_tol_array(i_model);
    s_pcc_ref_va = s_pcc_ref_va_cell{i_model};

    model_importer.Initialize();

    load_case = model_importer.load_case;

    HelperPowerflowResultMatchesSpec(test_case,load_case,solution_file_name,s_pcc_ref_va,abs_tol);
end



end

function TestPowerflowResultMatchesSpec_Manual(test_case)
load_case = GetLoadCaseIEEE_13_NoRegs_Manual();

solution_file_name = 'IEEE_13_NoRegs_Solution';

abs_tol = 2.5e-4;

s_pcc_ref_va = test_case.TestData.s_pcc_ieee_13_va;

HelperPowerflowResultMatchesSpec(test_case,load_case,solution_file_name,s_pcc_ref_va,abs_tol);
end


function HelperPowerflowResultMatchesSpec(test_case,load_case,solution_file_name,s_pcc_ref_va,abs_tol)
load_case.verbose = true;

solution_table = ParsePowerFlowSolutionData(solution_file_name);

V_spec = solution_table.V;

[u_pcc,t_pcc] = uot.ComplexToPolar(V_spec(1,:));

[U,T,p_pcc,q_pcc] = load_case.SolvePowerFlow(u_pcc,t_pcc);

V = uot.PolarToComplex(U,T);

network = load_case.network;

n_phase = network.n_phase;

n_sol = size(solution_table,1);

bus_number_array = network.GetBusNumber(solution_table.Row);

V_comp = V(bus_number_array,:);


[U_comp,T_comp] = uot.ComplexToPolar(V_comp);
[U_spec,T_spec] = uot.ComplexToPolar(V_spec);

diagnostic_string = sprintf('Result for power flow does not match spec for %s',solution_file_name);

verifyEqual(test_case,V_comp,V_spec,'AbsTol',abs_tol,diagnostic_string);

s_pcc = (p_pcc + 1i*q_pcc);
s_pcc_ref = s_pcc_ref_va/network.spec.s_base_va;

verifyEqual(test_case,s_pcc,s_pcc_ref,'AbsTol',abs_tol,diagnostic_string);

end


