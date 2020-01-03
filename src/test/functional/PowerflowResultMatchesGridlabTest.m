function tests = PowerflowResultMatchesGridlabTest
% PowerflowResultMatchesGridlabTest verifies that uot power flow solver matches the results from Gridlabd.

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

function TestPowerflowResultMatchesGridlab(test_case)

model_importer_array = GetModelImporterCatalogue();

for model_importer = model_importer_array(:).'
    file_name_gld_model = model_importer.spec.file_name_gld_model;
    fprintf('Now running: %s\n',file_name_gld_model);

    % We validating as part of the test. No need to do it twice.
    model_importer.validate = false;

    model_importer.Initialize();

    % We need to use the prerotated load case so that our results match
    % those from Gridlabd
    load_case = model_importer.load_case_prerot;

    u_pcc_array = model_importer.u_pcc_array;
    t_pcc_array = model_importer.t_pcc_array;

    [U_array,T_array,p_pcc_array,q_pcc_array] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);

    % Verify voltages
    U_ref_array = model_importer.U_ref_array;
    T_ref_array = model_importer.T_ref_array;

    V_array = uot.PolarToComplex(U_array,T_array);
    V_ref_array = uot.PolarToComplex(U_ref_array,T_ref_array);

    verifyEqual(test_case,V_array,V_ref_array,'AbsTol',test_case.TestData.abs_tol_equality)

    % Verify PCC load
    s_pcc_array = p_pcc_array + 1i*q_pcc_array;
    s_pcc_ref_array = model_importer.p_pcc_ref_array + 1i*model_importer.q_pcc_ref_array;

    verifyEqual(test_case,s_pcc_array,s_pcc_ref_array,'AbsTol',test_case.TestData.abs_tol_equality)

    % Verify Link current
    [I_link_from_array,I_link_to_array] = load_case.network.ComputeLinkCurrentsAndPowers(U_array,T_array);

    I_link_from_ref_array = model_importer.I_link_from_ref_array;
    I_link_to_ref_array = model_importer.I_link_to_ref_array;

    verifyEqual(test_case,I_link_from_array,I_link_from_ref_array,'AbsTol',test_case.TestData.abs_tol_equality)
    verifyEqual(test_case,I_link_to_array,I_link_to_ref_array,'AbsTol',test_case.TestData.abs_tol_equality);

end
end
