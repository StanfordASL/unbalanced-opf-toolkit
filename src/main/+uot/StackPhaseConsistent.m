function x_stacked = StackPhaseConsistent(x_array,x_has_phase)
size_x_has_phase = size(x_has_phase);
validateattributes(x_array,{'double','logical','sdpvar','ndsdpvar'},{'size',[size_x_has_phase,nan]})
validateattributes(x_has_phase,{'logical'},{'2d'})


% There is a bug with sdpvar that makes this necesary
if ndims(x_array) >= 3
    n_array = size(x_array,3);
else
    n_array = 1;
end

% Recall that zeros does not work for sdpvar
x_stacked_cell = cell(n_array,1);

for i_array = 1:n_array
    x_stacked_cell{i_array} = StackPhaseConsistentHelper(x_array(:,:,i_array),x_has_phase);
end

x_stacked = cat(2,x_stacked_cell{:});
end

function x_stacked = StackPhaseConsistentHelper(x,x_has_phase)
assert(numel(x) == numel(x_has_phase));
x_transpose = x.';
x_stacked = x_transpose(x_has_phase.');
end