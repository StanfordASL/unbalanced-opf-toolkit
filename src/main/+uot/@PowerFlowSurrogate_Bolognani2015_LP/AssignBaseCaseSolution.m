function [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)

network = obj.opf_problem.network;

u_pcc_array = obj.opf_problem.u_pcc_array;
t_pcc_array = obj.opf_problem.u_pcc_array;

[U_ast,T_ast] = obj.GetLinearizationVoltage();

load_case = obj.opf_problem.load_case;
[U_array, T_array, p_pcc_array, q_pcc_array]  = obj.SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,U_ast,T_ast);

U_array_stack = uot.StackPhaseConsistent(U_array,network.bus_has_phase);
T_array_stack = uot.StackPhaseConsistent(T_array,network.bus_has_phase);

assign(obj.decision_variables.U_array_stack,U_array_stack);
assign(obj.decision_variables.T_array_stack,T_array_stack);
end