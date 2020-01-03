function objective = DefineObjective_LoadCost(obj,objective_spec)
% |private| Define objective of minimizing the cost of controllable loads.
%
% Synopsis::
%
%   objective = obj.DefineObjective_LoadCost()
%
% Description:
%   Compute the cost of the controllable loads according to the specification
%   in |uot.OPFobjectiveSpec_LoadCost|.
%
%
% Arguments:
%   objective_spec (|uot.OPFobjectiveSpec_LoadCost|): Specification of controllable load cost
%
%
% Returns:
%
%   - **objective** (sdpvar) - Controllable load cost
%
% See Also:
%   |uot.OPFobjectiveSpec_LoadCost|
%
% Todo:
%
%   - Explain in |uot.OPFobjectiveSpec_LoadCost| what the cost entails


% .. Line with 80 characters for reference #####################################

validateattributes(objective_spec,{'uot.OPFobjectiveSpec_LoadCost'},{'scalar'},mfilename,'objective_spec',1);

n_load_cost_spec_array = numel(objective_spec.load_cost_spec_array);

load_cost = 0;

for i_load_cost_spec_array = 1:n_load_cost_spec_array
    load_cost_spec = objective_spec.load_cost_spec_array(i_load_cost_spec_array);

    load_name = load_cost_spec.load_name;

    cost_p_spec = load_cost_spec.cost_p;
    cost_q_spec = load_cost_spec.cost_q;

    controllable_load = obj.controllable_load_hashtable(load_name);

    if ~isempty(cost_p_spec)
        cost_p_spec_expanded = uot.ExpandBound(controllable_load.p,cost_p_spec);
        cost_p = cost_p_spec_expanded(:).'*controllable_load.p(:);
    else
        cost_p = 0;
    end

    if ~isempty(cost_q_spec)
        cost_q_spec_expanded = uot.ExpandBound(controllable_load.q,cost_q_spec);
        cost_q = cost_q_spec_expanded(:).'*controllable_load.q(:);
    else
        cost_q = 0;
    end

    load_cost = load_cost + cost_p + cost_q;
end

objective = load_cost;
end