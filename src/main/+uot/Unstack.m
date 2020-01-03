function x = Unstack(x_stacked)
    n_x = size(x_stacked,1)/3;
    %Check that n_x is an integer
    assert(n_x == round(n_x));
    assert(size(x_stacked,2) == 1);

    x = reshape(x_stacked,3,n_x).';
end