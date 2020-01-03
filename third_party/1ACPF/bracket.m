function BRX = bracket(X)

	BRX = [real(X), -imag(X); imag(X), real(X)];

