function [p_pcc_array,q_pcc_array] = GetPowerInjectionFromPCCload(obj)
p_pcc_array = obj.pcc_load.p;
q_pcc_array = obj.pcc_load.q;
end