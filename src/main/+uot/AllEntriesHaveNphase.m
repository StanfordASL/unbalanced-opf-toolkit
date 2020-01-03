function res = AllEntriesHaveNphase(x_array,n_phase)
n_phase_is_ok = arrayfun(@(x) numel(x.phase) == n_phase,x_array);
res = all(n_phase_is_ok);
end