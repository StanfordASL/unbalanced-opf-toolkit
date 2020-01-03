function res = IsUnbalancedPhaseVector(phase)
res = isrow(phase)  && islogical(phase) && sum(phase) > 0 && size(phase,2) == 3;
end