function tests = ConvertToLoadCasePyTest
% ConvertToLoadCasePyTest Verifies that conversion from LoadCaseZIP to LoadCasePy works

% This enables us to run the test without calling it from runtests
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

test_case.TestData.abs_tol_equality = 1e-9;
test_case.TestData.abs_tol_similarity = 1e-2;
end

function TestConvertToLoadCaseSimple(test_case)
% We do not include IEEE_13_LoadCatalogue because it has voltages
% outside spec (~1.08) and thus large error.
model_importer_array = [
    % Basic models
    GetModelImporterIEEE_13_NoRegs();
    GetModelImporterIEEE_13();
    GetModelImporterIEEE_123();
    %
    % Models with time-series loads
    GetModelImporterIEEE_13_NoRegs_Schedule();
    GetModelImporterHL0004();
    GetModelImporterPL0001();
    ];

for model_importer = model_importer_array(:).'
    model_importer.Initialize();

    load_case_zip = model_importer.load_case;

    u_pcc_array = model_importer.u_pcc_array;
    t_pcc_array = model_importer.t_pcc_array;

    [U_array_zip,T_array_zip,p_pcc_array_zip,q_pcc_array_zip] = load_case_zip.SolvePowerFlow(u_pcc_array,t_pcc_array);

    V_array_zip = uot.PolarToComplex(U_array_zip,T_array_zip);
    s_pcc_array_zip = p_pcc_array_zip + 1i*q_pcc_array_zip;

    load_case_py_exact = load_case_zip.ConvertToLoadCasePy(U_array_zip,T_array_zip);
    load_case_py_approx = load_case_zip.ConvertToLoadCasePy();

    [U_array_exact,T_array_exact,p_pcc_array_exact,q_pcc_array_exact] = load_case_py_exact.SolvePowerFlow(u_pcc_array,t_pcc_array);
    [U_array_approx,T_array_approx,p_pcc_array_approx,q_pcc_array_approx] = load_case_py_approx.SolvePowerFlow(u_pcc_array,t_pcc_array);

    V_array_exact = uot.PolarToComplex(U_array_exact,T_array_exact);
    V_array_approx = uot.PolarToComplex(U_array_approx,T_array_approx);

    s_pcc_array_exact = p_pcc_array_exact + 1i*q_pcc_array_exact;

    name = model_importer.spec.directory_gld_model;

    diagnostic_string_exact = sprintf('Voltage from load_case_py_exact outside tolerance for %s',name);
    verifyEqual(test_case,V_array_exact,V_array_zip,'AbsTol',test_case.TestData.abs_tol_equality,diagnostic_string_exact);
    diagnostic_string_exact = sprintf('Voltage from load_case_simple_aprox outside tolerance for %s',name);
    verifyEqual(test_case,V_array_approx,V_array_zip,'AbsTol',test_case.TestData.abs_tol_similarity,diagnostic_string_exact);

    % We only check the exact case for pcc power because the approximate one typically has larger errors.
    diagnostic_string_exact = sprintf('PCC power from load_case_py_exact outside tolerance for %s',name);
    verifyEqual(test_case,s_pcc_array_exact,s_pcc_array_zip,'AbsTol',test_case.TestData.abs_tol_equality,diagnostic_string_exact);
end


end


