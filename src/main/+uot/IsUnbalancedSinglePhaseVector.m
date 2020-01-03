function res = IsUnbalancedSinglePhaseVector(phase)
res = uot.IsUnbalancedPhaseVector(phase) && sum(phase) == 1;
end