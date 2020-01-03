function state_vector_ast = GetStateVectorForLinearization(obj)
[U_ast,T_ast] = obj.GetLinearizationVoltage(obj.linearization_point);
state_vector_ast = uot.PowerFlowSurrogate_Bolognani2015_LP.GetStateVectorAtVoltage(obj.opf_problem.network,U_ast,T_ast);
end