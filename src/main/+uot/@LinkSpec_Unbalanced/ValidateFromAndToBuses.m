function ValidateFromAndToBuses(obj,bus_spec_from,bus_spec_to)
% Validates that phases of link are compatible with those of from and to buses

assert(isa(bus_spec_from,'uot.BusSpec_Unbalanced'),sprintf('Error in %s: From side of uot.LinkSpec_Unbalanced must be an uot.BusSpec_Unbalanced.',obj.name))
assert(isa(bus_spec_to,'uot.BusSpec_Unbalanced'),sprintf('Error in %s: To side of uot.LinkSpec_Unbalanced must be an uot.BusSpec_Unbalanced.',obj.name))

assert(all(bus_spec_from.phase(obj.phase)),sprintf('Error in %s: obj.phase must be a subset of bus_data_from.phase',obj.name))
assert(all(bus_spec_to.phase == obj.phase),sprintf('Error in %s: bus_data_to.phase must be equal to obj.phase',obj.name))
end