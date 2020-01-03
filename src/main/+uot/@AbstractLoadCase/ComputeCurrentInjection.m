% Based on Bazrafshan2018a
function I_inj_array = ComputeCurrentInjection(obj,U_array,T_array)
V_array = uot.PolarToComplex(U_array,T_array);

V_s = uot.StackPhaseConsistent(V_array(1,:,:),obj.network.bus_has_phase(1,:));
V_n = uot.StackPhaseConsistent(V_array(2:end,:,:),obj.network.bus_has_phase(2:end,:));

I_inj_stack = obj.ComputeCurrentInjectionHelper(V_s,V_n);

I_inj_array = uot.UnstackPhaseConsistent(I_inj_stack,obj.network.bus_has_phase);
end