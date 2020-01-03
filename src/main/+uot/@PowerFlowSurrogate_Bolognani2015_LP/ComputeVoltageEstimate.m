function [U_array,T_array] = ComputeVoltageEstimate(obj)
network = obj.opf_problem.network;
U_array = uot.UnstackPhaseConsistent(value(obj.decision_variables.U_array_stack),network.bus_has_phase);
T_array = uot.UnstackPhaseConsistent(value(obj.decision_variables.T_array_stack),network.bus_has_phase);
end