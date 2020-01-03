function M = ExtractPhaseValuesFromMatrix(phase,M_pre)
    n_phase = numel(phase);

    if all(size(M_pre) == n_phase)
        M = M_pre(phase,phase);
    else
        M = M_pre;
    end
end

