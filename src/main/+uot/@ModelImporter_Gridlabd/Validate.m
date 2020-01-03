function Validate(obj)
% Validate Solve power flow using the imported data and compare result to Gridlabd's solver

% We need to use the prerotated load case so that our results match
% those from Gridlabd
[U_array,T_array,p_pcc_array,q_pcc_array] = obj.load_case_prerot.SolvePowerFlow(obj.u_pcc_array,obj.t_pcc_array);

U_ref_array = obj.U_ref_array;
T_ref_array = obj.T_ref_array;

% Compare voltages
V_array = uot.PolarToComplex(U_array,T_array);
V_ref_array = uot.PolarToComplex(U_ref_array,T_ref_array);

V_delta_array = abs(V_array - V_ref_array);

V_delta_array_stack = uot.StackPhaseConsistent(V_delta_array,obj.network.bus_has_phase);

V_delta_max_at_timestep = max(V_delta_array_stack,[],1);
[V_delta_max,i_time_step] = max(V_delta_max_at_timestep);

if V_delta_max > obj.validate_tol
    error('Voltage validation failed, error = %e at i_time_step = %i.',V_delta_max,i_time_step);
else
    if obj.verbose
        fprintf('Voltage validation passed, max error = %e.\n',V_delta_max);
    end
end

% Compare PCC load
s_pcc_array = p_pcc_array + 1i*q_pcc_array;
s_pcc_ref_array = obj.p_pcc_ref_array + 1i*obj.q_pcc_ref_array;

s_pcc_delta_array = abs(s_pcc_array - s_pcc_ref_array);

s_pcc_delta_max = max(s_pcc_delta_array(:));

if s_pcc_delta_max > obj.validate_tol
    error('PCC load validation failed, error = %e.\n',s_pcc_delta_max);
else
    if obj.verbose
        fprintf('PCC load validation passed, max error = %e.\n',s_pcc_delta_max);
    end
end

% Compare currents
[I_link_from_array,I_link_to_array] = obj.network.ComputeLinkCurrentsAndPowers(U_array,T_array);

I_link_from_delta_array = abs(I_link_from_array - obj.I_link_from_ref_array);
I_link_to_delta_array = abs(I_link_to_array - obj.I_link_to_ref_array);

I_link_from_delta_max = max(I_link_from_delta_array(:));
I_link_to_delta_max = max(I_link_to_delta_array(:));

if I_link_from_delta_max > obj.validate_tol
    error('Link current (from) validation failed, error = %e.\n',I_link_from_delta_max);
else
    if obj.verbose
        fprintf('Link current (from) validation passed, max error = %e.\n',I_link_from_delta_max);
    end
end

if I_link_to_delta_max > obj.validate_tol
    error('Link current (to) validation failed, error = %e.\n',I_link_to_delta_max);
else
    if obj.verbose
        fprintf('Link current (to) validation passed, max error = %e.\n',I_link_to_delta_max);
    end
end

end



















