function [U_array,T_array,p_pcc_array,q_pcc_array]  = SolvePFbaseCase(obj)
% Solves power flow without uncontrollable loads

u_pcc_array = obj.spec.pcc_voltage_spec.u_pcc_array;
t_pcc_array = obj.spec.pcc_voltage_spec.t_pcc_array;
[U_array,T_array, p_pcc_array, q_pcc_array] = obj.load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);
end