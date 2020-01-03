 function res = ExtractPhaseConsistentValues(A,has_phase)
    res = nan(size(has_phase));
    res(has_phase) = A(has_phase);
end