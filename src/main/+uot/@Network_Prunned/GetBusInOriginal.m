function bus_in_orginal = GetBusInOriginal(obj)
bus_in_orginal = zeros(obj.n_bus,1);

for i_bus = 1:obj.n_bus
    bus_name = obj.bus_data_array(i_bus).spec.name;

    i_bus_orginal = obj.network_full.GetBusNumber(bus_name);

    bus_in_orginal(i_bus) = i_bus_orginal;
end
end