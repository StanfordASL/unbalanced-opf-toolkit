function x_array = UnstackPhaseConsistent(x_stacked_array,x_has_phase)
validateattributes(x_has_phase,{'logical'},{'2d'})

n_array = size(x_stacked_array,2);

x_cell = cell(n_array);

for i_array = 1:n_array
    x_cell{i_array} = UnstackPhaseConsistentHelper(x_stacked_array(:,i_array),x_has_phase);
end

% We do this because otherwise the operation fails if x_stacked_array is
% an sdpvar
if n_array > 1
    x_array = cat(3,x_cell{:});
else
    x_array = x_cell{1};
end

end

function x = UnstackPhaseConsistentHelper(x_stacked,x_has_phase)
assert(numel(x_stacked) == sum(x_has_phase(:)));

x_has_phase_transposed = x_has_phase.';

if isa(x_stacked,'sdpvar')
    x_transposed = sdpvar(size(x_has_phase_transposed,1),size(x_has_phase_transposed,2));
    x_transposed(x_has_phase_transposed) = x_stacked;
    x_transposed(~x_has_phase_transposed) = nan;
elseif isa(x_stacked,'double')
    x_transposed = nan(size(x_has_phase_transposed));
    if ~isreal(x_stacked)
        x_transposed = x_transposed*(1 + 1i);
    end
    x_transposed(x_has_phase_transposed) = x_stacked;
else
    error('Behavior for class %s not specified.',class(x_stacked));
end

x = x_transposed.';
end