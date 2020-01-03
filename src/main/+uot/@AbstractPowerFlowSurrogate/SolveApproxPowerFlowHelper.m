function [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = SolveApproxPowerFlowHelper(pf_surrogate_spec,load_case,u_pcc_array,t_pcc_array)
% It is possible to solve power flow using a surrogate by minimizing the
% energy drawn from the reference bus without any operational constraints.

validateattributes(pf_surrogate_spec,{'uot.AbstractPowerFlowSurrogateSpec'},{'scalar'},mfilename,'pf_surrogate_spec',1);
validateattributes(load_case,{'uot.LoadCasePy'},{'scalar'},mfilename,'load_case',2);
load_case.ValidatePCCvoltage(u_pcc_array,t_pcc_array);

spec = CreateBasicOPFspec(pf_surrogate_spec,u_pcc_array,t_pcc_array);

opf_problem = uot.OPFproblem(spec,load_case);

opf_problem.Solve();

[U_array,T_array] = opf_problem.GetVoltageEstimate();
[p_pcc_array,q_pcc_array] = opf_problem.EvaluatePowerInjectionFromPCCload();
end

function spec = CreateBasicOPFspec(pf_surrogate_spec,u_pcc_array,t_pcc_array)
% No controllable loads since we are only solving power flow
controllable_load_spec_array = [];

% Minimizing energy drawn from the reference bus is equivalent to minimizing its cost
% Here we arbitrarily set a cost of 1 USD per MWh
substation_energy_cost_usd_per_j = 1/(1e6*3600);
objective_spec = uot.OPFobjectiveSpec_SubstationEnergyCost(substation_energy_cost_usd_per_j);

pcc_voltage_spec = uot.PCCvoltageSpec(u_pcc_array,t_pcc_array);

% No constraints on voltage magnitude since we are only solving power flow
voltage_magnitude_spec = uot.VoltageMaginitudeSpec();

spec = uot.OPFspec(pf_surrogate_spec,controllable_load_spec_array,objective_spec,pcc_voltage_spec,voltage_magnitude_spec);
end




