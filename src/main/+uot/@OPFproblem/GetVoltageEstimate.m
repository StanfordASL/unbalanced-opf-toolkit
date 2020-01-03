function [U_array,T_array] = GetVoltageEstimate(obj)
if obj.is_solved
    % Since ComputeVoltageEstimate may be expensive (for example for SDP), we cache
    % the results.
    if isempty(obj.U_array_cache) || isempty(obj.T_array_cache)
        [obj.U_array_cache,obj.T_array_cache] = obj.pf_surrogate.ComputeVoltageEstimate();
    end
    U_array = obj.U_array_cache;
    T_array = obj.T_array_cache;
else
     warning('Cannot GetVoltageEstimate before solving the optimization problem.')
     U_array = [];
     T_array = [];
end
end