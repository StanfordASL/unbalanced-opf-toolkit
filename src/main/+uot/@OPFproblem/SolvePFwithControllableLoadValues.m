function [U_array,T_array,p_pcc_array,q_pcc_array]  = SolvePFwithControllableLoadValues(obj)
load_case_new = obj.CreateLoadCaseIncludingControllableLoadValues();

u_pcc_array = obj.spec.pcc_voltage_spec.u_pcc_array;
t_pcc_array = obj.spec.pcc_voltage_spec.t_pcc_array;
[U_array,T_array, p_pcc_array, q_pcc_array] = load_case_new.SolvePowerFlow(u_pcc_array,t_pcc_array);
end