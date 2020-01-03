function bus_number_array = GetBusNumber(obj,bus_name_pre)
% GetBusNumber returns the number of a bus from its name
% Returns nan if not a bus
% bus_name_pre may be of type char or a cell of char

% Convert to cell if necessary
if ~isa(bus_name_pre,'cell')
    bus_name_cell = cellstr(bus_name_pre);
else
    bus_name_cell = bus_name_pre;
end

n_bus_name_cell = numel(bus_name_cell);

bus_number_array = zeros(n_bus_name_cell,1);

for i = 1:n_bus_name_cell
    bus_name = bus_name_cell{i};

    if obj.bus_name_map.isKey(bus_name)
        bus_number_array(i) = obj.bus_name_map(bus_name);
    else
        bus_number_array(i) = nan;
    end
end
end