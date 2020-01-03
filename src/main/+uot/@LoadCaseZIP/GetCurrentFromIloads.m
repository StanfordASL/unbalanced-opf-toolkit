function [I_i_stack,I_i_y_stack,I_i_d_stack] = GetCurrentFromIloads(obj,V_n)
% Note: here we assume that V_n has the same phases as bus_has_load_phase. This
% is only true when all buses have loads except the pcc. This is enforced
% in AbstractNetwork.CreateNetworkHelperMatrices

I_i_y_pre = -obj.I_y;
I_i_y_pre_stack = uot.StackPhaseConsistent(I_i_y_pre,obj.bus_has_load_phase);

% If the currents are already prerotated (e.g., because they came from
% Gridlab), there is no need to multiply them by V./abs(V) as done in
% Bazrafshan2018a.
if obj.spec.current_is_prerotated
    I_i_y_stack = I_i_y_pre_stack;
else
    I_i_y_stack = I_i_y_pre_stack.*(V_n./abs(V_n));
end

I_d_pre = obj.I_d;
I_d_pre_stack = uot.StackPhaseConsistent(I_d_pre,obj.bus_has_delta_load_phase);

if obj.spec.current_is_prerotated
    I_d_stack = I_d_pre_stack;
else
    V_delta_stack = obj.delta_network_matrix*V_n;

    I_d_stack = I_d_pre_stack.*(V_delta_stack./abs(V_delta_stack));
end

I_i_d_stack = -obj.delta_network_matrix.'*I_d_stack;

I_i_stack = I_i_y_stack + I_i_d_stack;
end