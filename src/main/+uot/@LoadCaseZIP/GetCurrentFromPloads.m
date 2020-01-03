function [I_p_stack,I_p_y_stack,I_p_d_stack] = GetCurrentFromPloads(obj,V_n)
% Note: here we assume that V_n has the same phases as bus_has_load_phase. This
% is only true when all buses have loads exept the pcc. This is enforced
% in AbstractNetwork.CreateNetworkHelperMatrices

I_p_y_stack = obj.GetCurrentFromPyloads(V_n);

S_d_stack = uot.StackPhaseConsistent(obj.S_d,obj.bus_has_delta_load_phase);

V_delta_stack = obj.delta_network_matrix*V_n;

I_p_d_stack = -obj.delta_network_matrix.'*conj(S_d_stack./V_delta_stack);

I_p_stack = I_p_y_stack + I_p_d_stack;
end