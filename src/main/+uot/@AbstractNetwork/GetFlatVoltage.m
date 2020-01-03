function v_flat = GetFlatVoltage(obj)
a = uot.FortescueOperator();
if obj.spec.is_positively_sequenced
    v_flat = [1, a^2, a];
else
    v_flat = [1, a, a^2];
end
end