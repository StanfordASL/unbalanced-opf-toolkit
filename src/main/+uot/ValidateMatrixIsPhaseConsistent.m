function ValidateMatrixIsPhaseConsistent(phase,M)
uot.ValidateAttributes(M,{'double'},{'square'})
uot.ValidateAttributes(phase,{'logical'},{@uot.IsPhaseVector})

n_phase = numel(phase);
n_phase_in_x = sum(phase);

if all(size(M) == n_phase)
    if ~all(all(M(~phase,~phase) == 0))
        error('Nonzero values in matrix where there is no phase.');
    end
elseif ~all(size(M) == n_phase_in_x)
    error('size of M must be either n_phase = %d or n_phase_in_x = %d',n_phase,n_phase_in_x);
end
end

