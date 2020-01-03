function [p_pcc_array_val,q_pcc_array_val] = EvaluatePowerInjectionFromPCCload(obj)
% Compute the current value of the |pcc| load
%
% Synopsis::
%
%   [p_pcc_array_val,q_pcc_array_val] = opf_problem.EvaluatePowerInjectionFromPCCload()
%
% Description:
%   Compute the current value of the |pcc| load (which is an sdpvar) and return it
%
%
%
% Returns:
%
%   - **p_pcc_array_val** (double) - Array(n_time_step,n_phase) with active power due to the |pcc| load
%   - **q_pcc_array_val** (double) - Array(n_time_step,n_phase) with reactive power due to the |pcc| load
%
% See Also:
%   :meth:`uot.OPFproblem.GetPowerInjectionFromPCCload<+uot.@OPFproblem.OPFproblem.GetPowerInjectionFromPCCload>`

% .. Line with 80 characters for reference #####################################

[p_pcc_array,q_pcc_array] = obj.GetPowerInjectionFromPCCload();
p_pcc_array_val = value(p_pcc_array);
q_pcc_array_val = value(q_pcc_array);
end