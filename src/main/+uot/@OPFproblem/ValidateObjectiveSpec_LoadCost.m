function ValidateObjectiveSpec_LoadCost(obj)
% Verifies that
%   - Load name is a valid controllable load
%   - cost_p and cost_q are phase consistent with p and q in controllable load

objective_spec = obj.spec.objective_spec;

assert(isa(objective_spec,'uot.OPFobjectiveSpec_LoadCost'),'objective_spec must be an uot.OPFobjectiveSpec_LoadCost.')

load_cost_spec_array = objective_spec.load_cost_spec_array;

n_load_cost_spec_array = numel(load_cost_spec_array);

for i = 1:n_load_cost_spec_array
    load_cost_spec = load_cost_spec_array(i);

    load_name = load_cost_spec.load_name;

    assert(obj.controllable_load_hashtable.isKey(load_name),'No controllable load named %s',load_name)

    controllable_load = obj.controllable_load_hashtable(load_name);

    % Validate that sizes of costs are consistent
    [n_row,n_col] = controllable_load.GetSsize();
    % This array has the same size as p and q
    s_size_proxy = zeros(n_row,n_col);

    uot.VerifyBoundSize(s_size_proxy,load_cost_spec.cost_p);
    uot.VerifyBoundSize(s_size_proxy,load_cost_spec.cost_q);
end
end