function bus_data_array = CreateBusDataArray(obj,bus_spec_array)
% CreateBusDataArray creates an array of BusData from an array of BusSpec.

% Note: this method does not change the object's state. It is not static
% so that MapBusSpecToBusData can be overriden by derived classes

i_swing_bus = find([bus_spec_array.bus_type] == uot.enum.BusType.Swing);

n_swing_bus = numel(i_swing_bus);
if n_swing_bus ~= 1
    error('There must be exactly 1 Swing bus in bus_data_array, there are %i.',n_swing_bus);
end

% By convention swing bus is the first one
bus_spec_array = bus_spec_array([i_swing_bus,1:(i_swing_bus-1),(i_swing_bus+1):end]);

n_bus_spec_array = numel(bus_spec_array);

% for run runs backwards to pre-allocate array in the first iteration
for i = n_bus_spec_array:-1:1
    bus_data_array(i) = obj.MapBusSpecToBusData(bus_spec_array(i));
end
end
