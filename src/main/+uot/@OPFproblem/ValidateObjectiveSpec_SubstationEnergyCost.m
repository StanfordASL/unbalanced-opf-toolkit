function ValidateObjectiveSpec_SubstationEnergyCost(obj)
% Verifies that
%   - substation_energy_cost_usd_per_j is scalar or has n_time_step elements

n_time_step = obj.n_time_step;

substation_energy_cost_usd_per_j = obj.spec.objective_spec.substation_energy_cost_usd_per_j;

assert(numel(substation_energy_cost_usd_per_j) == 1 || numel(substation_energy_cost_usd_per_j) == n_time_step, 'substation_energy_cost_usd_per_j must be a scalar or a vector with n_time_step elements.')
end