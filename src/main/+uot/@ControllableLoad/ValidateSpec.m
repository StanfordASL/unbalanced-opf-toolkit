function ValidateSpec(obj)
% Overrides uot.Object.ValidateSpec
network = obj.opf_problem.network;

name = obj.spec.name;

% Validate that bus exists in network
bus_name = obj.spec.attachment_bus;

bus_number = network.GetBusNumber(bus_name);

% Recall that GetBusNumber returns nan if bus_name is not found
% in network.
assert(isfinite(bus_number),'Attachment bus %s of controllable load %s does not exist in network',bus_name,name);

assert(bus_number ~= 1,'Attachment bus may not be the pcc.')

% Validate that all phases in load exist in attachement bus
phase = obj.spec.phase;
bus_phase = network.bus_has_phase(bus_number,:);

assert(all(bus_phase(phase)),'Controllable load %s has phases that do not appear in attachment bus %s',name,bus_name);

% Validate that sizes of bounds are consistent
[n_row,n_col] = obj.GetSsize();
% This array has the same size as p and q
s_size_proxy = zeros(n_row,n_col);

uot.VerifyBoundSize(s_size_proxy,obj.spec.p_min_va);
uot.VerifyBoundSize(s_size_proxy,obj.spec.p_max_va);

uot.VerifyBoundSize(s_size_proxy,obj.spec.q_min_va);
uot.VerifyBoundSize(s_size_proxy,obj.spec.q_max_va);

uot.VerifyBoundSize(s_size_proxy,obj.spec.power_factor_min);
uot.VerifyBoundSize(s_size_proxy,obj.spec.power_factor_max);

uot.VerifyBoundSize(s_size_proxy,obj.spec.s_mag_max_va);

% Sum across phases
s_sum_size_proxy = sum(s_size_proxy,2);

uot.VerifyBoundSize(s_sum_size_proxy,obj.spec.s_sum_mag_max_va);

% Compute difference across time
s_delta_size_proxy = diff(s_size_proxy,1,1);

uot.VerifyBoundSize(s_delta_size_proxy,obj.spec.p_delta_max_va);
uot.VerifyBoundSize(s_delta_size_proxy,obj.spec.q_delta_max_va);

% Verify that powr factor constraints are convex
if ~isempty(obj.spec.power_factor_min)
    assert(~isempty(obj.spec.p_min_va) && all(obj.spec.p_min_va(:) >= 0),'power_factor_min is only supported for p_min_va >= 0 (otherwise the constraint is not convex)')
end

if ~isempty(obj.spec.power_factor_max)
    assert(~isempty(obj.spec.p_max_va) && all(obj.spec.p_max_va(:) <= 0),'power_factor_max is only supported for p_max_va <= 0 (otherwise the constraint is not convex)')
end
end