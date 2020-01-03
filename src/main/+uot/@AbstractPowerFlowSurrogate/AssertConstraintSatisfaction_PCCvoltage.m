function AssertConstraintSatisfaction_PCCvoltage(obj,U_array_val,T_array_val)
% Some of the power flow surrogates do not estimate phase. In this case we
% only check magnitude
if isempty(T_array_val)
u_pcc_array_val = uot.PermuteDims1and3(U_array_val(1,:,:));

u_pcc_array_ref = obj.opf_problem.spec.pcc_voltage_spec.u_pcc_array;

assert(max(abs(u_pcc_array_val(:) - u_pcc_array_ref(:))) <= obj.constraint_tol,'Voltage magnitudes at pcc do not match.')

else

v_pcc_array_val_pre = uot.PolarToComplex(U_array_val(1,:,:),T_array_val(1,:,:));
v_pcc_array_val = uot.PermuteDims1and3(v_pcc_array_val_pre);

v_pcc_array_ref = obj.opf_problem.spec.pcc_voltage_spec.v_pcc_array;

assert(max(abs(v_pcc_array_val(:) - v_pcc_array_ref(:))) <= obj.constraint_tol,'Voltages at pcc do not match.')
end

end
