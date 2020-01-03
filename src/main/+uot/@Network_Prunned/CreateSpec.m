% This method is private and static
function spec = CreateSpec(network_full,removed_bus_name_map)
% CreateSpec Creates a spec for a prunned network from the full network and cell of buses to be removed
%   spec = CreateSpec(network_full,removed_bus_name_map)
%   network_full is the full network
%   removed_bus_name_map is a set (implemented as containers.Map) with the names of buses to be removed

spec_full = network_full.spec;

keep_bus_spec = arrayfun(@(bus_spec) ~removed_bus_name_map.isKey(bus_spec.name),spec_full.bus_spec_array);

bus_spec_array = spec_full.bus_spec_array(keep_bus_spec);

% Keep only links where neither from nor to buses were removed
keep_link_spec = arrayfun(@(link_spec) ~(removed_bus_name_map.isKey(link_spec.from) || removed_bus_name_map.isKey(link_spec.to)),spec_full.link_spec_array);

link_spec_array = spec_full.link_spec_array(keep_link_spec);

% Recall that spec is a value class and we are modifying a copy.
spec = spec_full;
spec.bus_spec_array = bus_spec_array;
spec.link_spec_array = link_spec_array;
end