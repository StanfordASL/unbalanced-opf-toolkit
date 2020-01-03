function power_factor_min_constraint = CreatePowerFactorMinConstraint(p,q,power_factor_min)
power_factor_min_bar = uot.ComputePowerFactorBar(power_factor_min);

if ~isempty(power_factor_min)
    power_factor_min_constraint = [
        uot.TagConstraintIfNonEmpty(p.*power_factor_min_bar - q >= 0,'power_factor_min_bar_1');
        uot.TagConstraintIfNonEmpty(p.*power_factor_min_bar + q >= 0,'power_factor_min_bar_2');
        ];
else
    power_factor_min_constraint = [];
end

end