function AssignControllableLoadsToNoLoad(obj)
% |private| Assign no load solution to controllable loads
%
% Description:
%	This methods assigns zero load to the controllable loads.
%

% .. Line with 80 characters for reference #####################################

for controllable_load_c = obj.controllable_load_hashtable.values
	assert(numel(controllable_load_c) == 1)
    controllable_load = controllable_load_c{1};

    controllable_load.AssignNoLoad();
end
end