function ValidateFromAndToBuses(obj,bus_spec_from,bus_spec_to)
% Validates that phases of link are compatible with those of from and to buses

assert(isa(bus_spec_from,'uot.BusSpec_Splitphased'),sprintf('Error in %s: From side of uot.LinkSpec_Splitphased must be an uot.BusSpec_Splitphased.',obj.name))
assert(isa(bus_spec_to,'uot.BusSpec_Splitphased'),sprintf('Error in %s: To side of uot.LinkSpec_Splitphased must be an uot.BusSpec_Splitphased.',obj.name))

assert(all(bus_spec_to.parent_phase == bus_spec_from.parent_phase),sprintf('Error in %s: bus_spec_to.parent_phase must match bus_spec_from.parent_phase.',obj.name))
end