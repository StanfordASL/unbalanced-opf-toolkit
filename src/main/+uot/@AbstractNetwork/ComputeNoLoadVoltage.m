function [U_noload_array,T_noload_array,w] = ComputeNoLoadVoltage(obj,u_pcc_array,t_pcc_array)
v_pcc_array = uot.PolarToComplex(u_pcc_array,t_pcc_array);

w = obj.Ybus_NN_U\(obj.Ybus_NN_L\(-obj.Ybus_NS*(v_pcc_array.')));

V_noload_array_stack = [v_pcc_array.';w];
V_noload_array = uot.UnstackPhaseConsistent(V_noload_array_stack, obj.bus_has_phase);

[U_noload_array,T_noload_array] = uot.ComplexToPolar(V_noload_array);
end