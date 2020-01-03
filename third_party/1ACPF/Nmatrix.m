function N = Nmatrix(d)

	N = [eye(d/2), zeros(d/2); zeros(d/2), -eye(d/2)];

