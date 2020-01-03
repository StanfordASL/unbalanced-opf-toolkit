function [U_array,T_array, p_pcc_array, q_pcc_array] = SolvePowerFlow(obj,u_pcc_array,t_pcc_array)
% Solve power flow for the load case acting on the network.
%
% Synopsis::
%
%   [U_array,T_array, p_pcc_array, q_pcc_array] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array)
%
% Description:
%   This function uses the Zbus iterative method :cite:`Bazrafshan2018a` to solve 
%   the power flow problem.
%   
%
% Arguments:
%   u_pcc_array (double): Array with voltage magnitude at the |pcc|
%   t_pcc_array (double): Array with phase at the |pcc|
%
%
% Returns:
%
%   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
%   - **T_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage angles
%   - **p_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with active power injection at the |pcc|
%   - **q_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with reactive power injection at the |pcc|

% .. Line with 80 characters for reference #####################################
    
    
obj.ValidatePCCvoltage(u_pcc_array,t_pcc_array);

network = obj.network;

[~,~,w] = network.ComputeNoLoadVoltage(u_pcc_array,t_pcc_array);

% V_s is pcc voltage
% w is no load voltage for all other nodes
v_pcc_array = uot.PolarToComplex(u_pcc_array,t_pcc_array);
V_s = v_pcc_array.';

% We use w as initial guess
V_n = w;

for iter = 1:obj.pf_max_iter
    [~,I_n] = obj.ComputeCurrentInjectionHelper(V_s,V_n);

    V_n_new = network.Ybus_NN_U\(network.Ybus_NN_L\I_n) + w;

    V_n_difference = (V_n - V_n_new);

    V_n_difference_max_abs = max(abs(V_n_difference(:)));

    if V_n_difference_max_abs <= obj.pf_abs_tol
        if obj.verbose
            fprintf('Solved in %d iterations, error = %d.\n',iter,V_n_difference_max_abs)
        end
        break;
    end

    V_n = V_n_new;
end

if iter == obj.pf_max_iter
    warning('SolvePF did not converge, residual = %f after reaching max_iter = %d.\n',V_n_difference_max_abs,obj.pf_max_iter);
end

V_array_stacked = [V_s;V_n];
V_array = uot.UnstackPhaseConsistent(V_array_stacked, network.bus_has_phase);

[U_array,T_array] = uot.ComplexToPolar(V_array);

I_s = network.Ybus_SS*V_s + network.Ybus_SN*V_n_new;

S_s = V_s.*conj(I_s);

p_pcc_array = real(S_s).';
q_pcc_array = imag(S_s).';
end