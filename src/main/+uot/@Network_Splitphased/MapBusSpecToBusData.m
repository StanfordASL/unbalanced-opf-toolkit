function bus_data = MapBusSpecToBusData(obj,bus_spec)
% Note: this class is meant to be called from the constructor. Hence,
% it should not access non-constant properties and non-static methods of obj.

phase = false(1,obj.n_phase);

switch class(bus_spec)
    case 'uot.BusSpec_Unbalanced'
        phase(obj.phase_primary) = bus_spec.phase;

    case 'uot.BusSpec_Splitphased'
        phase(obj.phase_secondary) = true;

    otherwise
        error('Invalid bus_spec class %s',class(bus_spec));
end

bus_data = uot.BusData(bus_spec,phase);
end