function R = Rmatrix(V,TH)

	VV = diag(V);
	COSTH = diag(cos(TH));
	SINTH = diag(sin(TH));

	R = [COSTH, -VV*SINTH; SINTH, VV*COSTH];


