function power_factor_max_constraint = CreatePowerFactorMaxConstraint(p,q,power_factor_max)
power_factor_max_bar = uot.ComputePowerFactorBar(power_factor_max);

if ~isempty(power_factor_max)
    power_factor_max_constraint = [
        uot.TagConstraintIfNonEmpty(p.*power_factor_max_bar - q >= 0,'power_factor_max_bar_1');
        uot.TagConstraintIfNonEmpty(p.*power_factor_max_bar + q >= 0,'power_factor_max_bar_2');
        ];
else
    power_factor_max_constraint = [];
end

end