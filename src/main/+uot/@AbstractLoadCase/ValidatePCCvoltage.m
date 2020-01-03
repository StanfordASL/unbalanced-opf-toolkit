function ValidatePCCvoltage(obj,u_pcc_array,t_pcc_array)
x_pcc_array_size = [obj.spec.n_time_step,obj.network.n_phase_pcc];
validateattributes(u_pcc_array,{'double'},{'size',x_pcc_array_size})
validateattributes(t_pcc_array,{'double'},{'size',x_pcc_array_size})

if ~all(uot.VoltageIsPositivelySequenced(t_pcc_array)) && obj.network.spec.is_positively_sequenced
    warning('Network is specified as positively sequenced but t_pcc_array is not.')
end
end