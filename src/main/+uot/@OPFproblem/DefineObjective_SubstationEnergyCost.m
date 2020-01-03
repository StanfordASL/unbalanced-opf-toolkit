function energy_cost_pcc = DefineObjective_SubstationEnergyCost(obj,objective_spec)

validateattributes(objective_spec,{'uot.OPFobjectiveSpec_SubstationEnergyCost'},{'scalar'},mfilename,'objective_spec',1);

objective_spec = obj.spec.objective_spec;

p_pcc_array = obj.GetPowerInjectionFromPCCload();

% We sum substation load across phases
p_pcc_sum_array = sum(p_pcc_array,2);

% Energy per time_step
% E = time_step_s*p_w
% p_w = p*s_base_va

% Cost of energy
% cost_E = time_step_s*s_base_va*substation_energy_cost_usd_per_j*p
% cost_E = factor*p

time_step_s = obj.load_case.spec.time_step_s;
s_base_va = obj.s_base_va;

substation_energy_cost_usd_per_j_pre = objective_spec.substation_energy_cost_usd_per_j;

substation_energy_cost_usd_per_j = uot.ExpandBound(p_pcc_sum_array(:),substation_energy_cost_usd_per_j_pre(:));

factor_USD = time_step_s*s_base_va*substation_energy_cost_usd_per_j;

energy_cost_pcc = factor_USD(:).'*p_pcc_sum_array(:);
end