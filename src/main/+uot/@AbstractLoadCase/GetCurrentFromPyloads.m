function I_p_y_stack = GetCurrentFromPyloads(obj,V_n)
network = obj.network;

S_y_stack = uot.StackPhaseConsistent(obj.S_y,obj.bus_has_load_phase);

I_p_y_stack = -conj(S_y_stack./V_n);
end