function [I_inj_stack,I_n] = ComputeCurrentInjectionHelper(obj,V_s,V_n)
I_p_y_stack = obj.GetCurrentFromPyloads(V_n);
I_n = I_p_y_stack;

I_s = obj.network.Ybus_SS*V_s + obj.network.Ybus_SN*V_n;

I_inj_stack = [I_s;I_n];
end