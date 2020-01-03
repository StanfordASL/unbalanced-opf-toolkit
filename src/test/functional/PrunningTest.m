
function tests = PrunningTest
% PrunningTest Verifies that pruning works correctly.

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

test_case.TestData.model_importer_array = [
    GetModelImporterSPCT_TriplexLoad();
    GetModelImporterSPCT_TriplexLoad120();
    GetModelImporterSPCT_TriplexLoad2400();
    GetModelImporterTaxonomy_R1_4();
    GetModelImporterTaxonomy_R3_3();
    GetModelImporterTaxonomy_R5_5();
    ];

test_case.TestData.abs_tol_equality = 1e-8;
end

function TestPowerflowApproximation(test_case)
% TestPowerflowApproximation Verifies that the power flow solution is close for the prunned and non-prunned networks.

for model_importer = test_case.TestData.model_importer_array(:).'
    file_name_gld_model = model_importer.spec.file_name_gld_model;
    fprintf('Now running: %s\n',file_name_gld_model);

    model_importer.Initialize();

    network_full = model_importer.network;
    % We need to use the prerotated load case so that our results match
    % those from Gridlabd
    load_case_full = model_importer.load_case_prerot;

    u_pcc_array = model_importer.u_pcc_array;
    t_pcc_array = model_importer.t_pcc_array;

    network = network_full.CreateNetworkWithPrunedSecondaries();
    network.verbose = true;
    load_case = network.AdaptLoadCase(load_case_full,u_pcc_array,t_pcc_array);

    [U_array_full,T_array_full,p_pcc_array_full,q_pcc_array_full] = load_case_full.SolvePowerFlow(u_pcc_array,t_pcc_array);

    [U_array,T_array,p_pcc_array,q_pcc_array] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);

    bus_in_orginal = network.GetBusInOriginal();

    n_phase = network.n_phase;

    U_array_ref = U_array_full(bus_in_orginal,1:n_phase,:);
    T_array_ref = T_array_full(bus_in_orginal,1:n_phase,:);

    V_array = uot.PolarToComplex(U_array,T_array);
    V_ref_array = uot.PolarToComplex(U_array_ref,T_array_ref);

    verifyEqual(test_case,V_array,V_ref_array,'AbsTol',test_case.TestData.abs_tol_equality)

    s_pcc_array = p_pcc_array + 1i*q_pcc_array;
    s_pcc_array_pre_ref = p_pcc_array_full + 1i*q_pcc_array_full;
    s_pcc_array_ref = s_pcc_array_pre_ref(:,1:n_phase);

    verifyEqual(test_case,s_pcc_array,s_pcc_array_ref,'AbsTol',test_case.TestData.abs_tol_equality)
end

end


function TestPrunning(test_case)
% TestPrunning Verifies that the prunned network contains all unbalanced buses and links from the original network and nothing else (i.e., split-phased stuff).


for model_importer = test_case.TestData.model_importer_array(:).'
    file_name_gld_model = model_importer.spec.file_name_gld_model;
    fprintf('Now running: %s\n',file_name_gld_model);

    model_importer.Initialize();

    network_full = model_importer.network;
    network = network_full.CreateNetworkWithPrunedSecondaries();

    % Verify that all unbalanced buses in network_full are also in network
    bus_spec_full_array = network_full.spec.bus_spec_array;
    bus_spec_full_unbalanced_array = uot.FilterArrayByClass(bus_spec_full_array,'uot.BusSpec_Unbalanced');
    % Sort so that order matches
    bus_name_full_unbalanced_cell = sort({bus_spec_full_unbalanced_array.name}.');

    bus_name_cell = sort({network.spec.bus_spec_array.name}.');

    verifyEqual(test_case,bus_name_cell,bus_name_full_unbalanced_cell)

    % Verify that all unbalanced links in network_full are also in network
    link_spec_full_array = network_full.spec.link_spec_array;
    link_spec_full_unbalanced_array = uot.FilterArrayByClass(link_spec_full_array,'uot.LinkSpec_Unbalanced');
    % Sort so that order matches
    link_name_full_unbalanced_cell = sort({link_spec_full_unbalanced_array.name}.');

    link_name_cell = sort({network.spec.link_spec_array.name}.');

    verifyEqual(test_case,link_name_cell,link_name_full_unbalanced_cell)

end
end






