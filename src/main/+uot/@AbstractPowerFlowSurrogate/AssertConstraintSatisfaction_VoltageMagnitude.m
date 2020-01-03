function AssertConstraintSatisfaction_VoltageMagnitude(obj,U_array_val)

% Note that voltage magnitude constraint does not apply to PCC
U_array_val_no_pcc = U_array_val(2:end,:,:);
bus_has_phase_no_pcc = obj.opf_problem.network.bus_has_phase(2:end,:);
U_array_val_stack = uot.StackPhaseConsistent(U_array_val_no_pcc,bus_has_phase_no_pcc);

u_min = obj.opf_problem.spec.voltage_magnitude_spec.u_min;
u_max = obj.opf_problem.spec.voltage_magnitude_spec.u_max;

tag_u = 'voltage maginitude';
uot.AssertLowerBoundSatisfaction(U_array_val_stack,u_min,obj.constraint_tol,tag_u);
uot.AssertUpperBoundSatisfaction(U_array_val_stack,u_max,obj.constraint_tol,tag_u);
end