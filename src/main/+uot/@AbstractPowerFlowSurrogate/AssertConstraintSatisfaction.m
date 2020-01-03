function AssertConstraintSatisfaction(obj)
[U_array_val,T_array_val] = obj.opf_problem.GetVoltageEstimate();
AssertConstraintSatisfaction_PCCvoltage(obj,U_array_val,T_array_val);
AssertConstraintSatisfaction_VoltageMagnitude(obj,U_array_val)
end

