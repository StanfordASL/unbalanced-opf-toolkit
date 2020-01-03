function [I_inj_stack,I_n] = ComputeCurrentInjectionHelper(obj,V_s,V_n)
I_i_stack = obj.GetCurrentFromIloads(V_n);
I_p_stack = obj.GetCurrentFromPloads(V_n);
I_z_stack = obj.GetCurrentFromZloads(V_n);

I_n = I_i_stack + I_p_stack + I_z_stack;

I_s = obj.network.Ybus_SS*V_s + obj.network.Ybus_SN*V_n;

I_inj_stack = [I_s;I_n];
end