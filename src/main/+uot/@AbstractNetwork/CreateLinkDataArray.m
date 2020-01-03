function link_data_array = CreateLinkDataArray(obj,link_spec_array,bus_name_map,bus_data_array,s_base_va)
% CreateBusDataArray creates an array of LinkData from an array of LinkSpec.

% Note: this method does not change the object's state. It is not static
% so that MapBusSpecToBusData can be overriden by derived classes

validateattributes(link_spec_array,{'uot.AbstractLinkSpec'},{},mfilename,'link_spec_array',1)
validateattributes(bus_name_map,{'containers.Map'},{},mfilename,'bus_name_map',2)
validateattributes(bus_data_array,{'uot.BusData'},{},mfilename,'bus_data_array',3)
validateattributes(s_base_va,{'double'},{'positive'},mfilename,'s_base_va',4)

n_link = numel(link_spec_array);

% for run runs backwards to pre-allocate array in the first iteration
for i_link = n_link:-1:1
    link_spec = link_spec_array(i_link);

    from_i = bus_name_map(link_spec.from);
    to_i = bus_name_map(link_spec.to);

    bus_spec_from = bus_data_array(from_i).spec;
    bus_spec_to = bus_data_array(to_i).spec;

    link_spec.ValidateYmatrices();
    link_spec.ValidateFromAndToBuses(bus_spec_from,bus_spec_to);

    link_data_array(i_link) = obj.MapLinkSpecToLinkData(link_spec,from_i,to_i,bus_spec_from,bus_spec_to,s_base_va);
end
end
