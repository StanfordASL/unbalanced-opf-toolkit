%% Solve power flow problem
% We solve a power flow problem using UOT's solver.

%%
clear variables
aaSetupPath

% If true, use GridLAB-D to get the power network model
use_gridlab = false;

%% Initialize network and loads
% Create a LoadCase object which includes the network and loads. Also
% define the voltage at the PCC bus.

% Get load case and voltage at PCC
if use_gridlab
    model_importer = GetModelImporterIEEE_13_NoRegs();
    model_importer.Initialize();

    load_case = model_importer.load_case_prerot;

    u_pcc_array = model_importer.u_pcc_array;
    t_pcc_array = model_importer.t_pcc_array;
else
    load_case = GetLoadCaseIEEE_13_NoRegs_Manual();

    u_pcc_array = [1, 1, 1];
    t_pcc_array = deg2rad([0, -120, 120]);
end

%% Solve power flow
% Solve power flow with UOT's solver.
[U_array,T_array,p_pcc_array,q_pcc_array] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);

U_array
