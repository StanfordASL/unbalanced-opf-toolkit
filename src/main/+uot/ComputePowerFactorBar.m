function power_factor_bar = ComputePowerFactorBar(power_factor)
power_factor_bar = sqrt(1 - power_factor.^(-2))/power_factor;
end