function constraint_array = GetConstraintArray(obj)
% Set fixed line currents according to linearization option
[U_ast,T_ast] = obj.GetLinearizationVoltage(obj.linearization_point);
obj.decision_variables.L_link_cell = obj.ComputeConstantLinkCurrents(U_ast,T_ast);

% Note: no extra constraints, only those from the super class.
constraint_array = GetConstraintArray@uot.PowerFlowSurrogate_Gan2014(obj);
end