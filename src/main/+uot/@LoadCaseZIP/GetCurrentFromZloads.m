function [I_z_stack,I_z_y_stack,I_z_d_stack] = GetCurrentFromZloads(obj,V_n)
% Note: here we assume that V_n has the same phases as bus_has_load_phase. This
% is only true when all buses have loads exept the pcc. This is enforced
% in AbstractNetwork.CreateNetworkHelperMatrices

Y_y_stack = uot.StackPhaseConsistent(obj.Y_y,obj.bus_has_load_phase);

I_z_y_stack = -Y_y_stack.*V_n;

Y_d_stack = uot.StackPhaseConsistent(obj.Y_d,obj.bus_has_delta_load_phase);

V_delta_stack = obj.delta_network_matrix*V_n;

I_z_d_stack = -obj.delta_network_matrix.'*(Y_d_stack.*V_delta_stack);

I_z_stack = I_z_y_stack + I_z_d_stack;
end