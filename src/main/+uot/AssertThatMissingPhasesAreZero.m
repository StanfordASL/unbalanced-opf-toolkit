function AssertThatMissingPhasesAreZero(A,has_phase)
has_phase_expanded = uot.ExpandBound(A, has_phase);
assert(all(A(~has_phase_expanded) == 0));
end