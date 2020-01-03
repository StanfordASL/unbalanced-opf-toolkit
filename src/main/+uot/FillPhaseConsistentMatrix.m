function res = FillPhaseConsistentMatrix(val,has_phase)
res = nan(size(has_phase));
res(has_phase) = val;
end