function res = IsPhaseVector(phase)
res = isrow(phase)  && islogical(phase) && sum(phase) > 0;
end