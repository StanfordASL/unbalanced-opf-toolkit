function ValidateSpec(obj)
% Overrides uot.Object.ValidateSpec

% Validate specs of controllable loads
controllable_load_cell = obj.controllable_load_hashtable.values.';

n_controllable_load_cell = numel(controllable_load_cell);

for i_controllable_load_cell = 1:n_controllable_load_cell
   controllable_load_cell{i_controllable_load_cell}.ValidateSpec();
end


obj.ValidateObjectiveSpec()

end

