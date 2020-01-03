function bus_data = MapBusSpecToBusData(obj,bus_spec)
% Note: this method is meant to be called from the constructor. Hence,
% it should not access non-constant properties and non-static methods of obj.

switch class(bus_spec)
    case 'uot.BusSpec_Unbalanced'
        phase = bus_spec.phase;

    otherwise
        error('Invalid bus_spec class %s',class(bus_spec));
end

bus_data = uot.BusData(bus_spec,phase);
end