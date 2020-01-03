function MustBeMustBeUnbalancedPhaseVectorOrEmpty(phase)
assert(isempty(phase) || uot.IsUnbalancedPhaseVector(phase),'Argument must be unbalanced phase vector')
end