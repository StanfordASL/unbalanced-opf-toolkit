function MustBeUnbalancedSinglePhaseVectorOrEmpty(phase)
assert(isempty(phase) || uot.IsUnbalancedSinglePhaseVector(phase),'Argument must be unbalanced single phase vector')
end