function controllable_load_hashtable = CreateControllableLoadHashTable(obj)
% |private| Instantiate controllable loads based on specifications and store them in a hash table
%
% Synopsis::
%
%   controllable_load_hashtable = obj.CreateControllableLoadHashTable()
%
% Description:
% 	Instantiate controllable loads based on the specifications in
% 	:attr:`obj.spec.controllable_load_spec_array`. Store the resulting controllable loads
%	in a hash table.
%
%
% Returns:
%
%   - **controllable_load_hashtable** (:class:`containers.Map`) - Hash table of controllable loads
%
% Note:
%
% 	- We use a hash table to store the controllable loads so that we can refer
%	  to them by name
%
%	- The hash table is implemented as a :class:`containers.Map`
%

% .. Line with 80 characters for reference #####################################



controllable_load_spec_array = obj.spec.controllable_load_spec_array;

controllable_load_hashtable = containers.Map;

for controllable_load_spec = controllable_load_spec_array.'
    assert(numel(controllable_load_spec) == 1)

    name = controllable_load_spec.name;

    controllable_load = uot.ControllableLoad(controllable_load_spec,obj);

    controllable_load_hashtable(name) = controllable_load;
end
end