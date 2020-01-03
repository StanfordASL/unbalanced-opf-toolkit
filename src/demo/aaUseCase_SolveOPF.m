%% Solve optimal power flow problem
% We solve an optimal power flow problem using UOT.

%%
clear variables
aaSetupPath

% If true, use GridLAB-D to get the power network model
use_gridlab = false;

%% Initialize OPF problem
% We use the power flow surrogate BFM SDP from Gan2014
pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_SDP();
opf_problem = GetExampleOPFproblem(pf_surrogate_spec,use_gridlab);

% Select solver
opf_problem.sdpsettings = sdpsettings('solver','sedumi');

%% Solve OPF problem
% Solve optimization problem
[objective_value,solver_time,diagnostics] = opf_problem.Solve();

% Estimate voltage from result of optimization problem
[U_array,T_array]= opf_problem.GetVoltageEstimate();

%% Verify if the solution is exact
% Compare the indirect variables (voltages at non-PCC buses and power
% injection at PCC) from the optimization problem and the power flow
% solution. If they match, then the solution is exact.

% Solve power flow using the controllable loads computed in the optimization
[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = opf_problem.SolvePFwithControllableLoadValues();

% Convert polar representation to complex
V_array = uot.PolarToComplex(U_array,T_array);
V_array_ref = uot.PolarToComplex(U_array_ref,T_array_ref);

% Compare voltages at non-PCC buses
V_array_error = abs(V_array - V_array_ref);
V_array_error_max = max(V_array_error(:))

% Compare power injection at PCC
[p_pcc_array,q_pcc_array] = opf_problem.EvaluatePowerInjectionFromPCCload();
s_pcc_array = p_pcc_array + 1i*q_pcc_array;
s_pcc_array_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;

s_pcc_array_ref_error = abs(s_pcc_array - s_pcc_array_ref);

s_pcc_array_ref_error_max = max(s_pcc_array_ref_error(:))
