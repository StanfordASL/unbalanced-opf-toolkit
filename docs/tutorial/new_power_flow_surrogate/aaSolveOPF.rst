.. This rst was auto-generated from MATLAB code.
.. To make changes, update the MATLAB code and republish this document.

Trying out the power flow surrogate
---------------------------------------------------------------------------------------------------
We try solving an OPF problem with our brand new surrogate.

*Generated from aaSolveOPF.m*    
    

.. code-block:: matlab

	clear variables
	aaSetupPath


Initialize OPF problem
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: matlab

	pf_surrogate_spec = PowerFlowSurrogateSpec_Bernstein2017_LP_3();
	use_gridlab = false;
	opf_problem = GetExampleOPFproblem(pf_surrogate_spec,use_gridlab);
	
	% Select solver
	opf_problem.sdpsettings = sdpsettings('solver','sedumi');


Solve OPF problem
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The problem is infeasible (see error message at the bottom) which suggests that there might a bug in our implementation. As we mentioned at the beginning, implementing power flow surrogates is an error prone process.

.. code-block:: matlab

	[objective_value,solver_time,diagnostics] = opf_problem.Solve();


.. code-block:: console  

	SeDuMi 1.32 by AdvOL, 2005-2008 and Jos F. Sturm, 1998-2003.
	Alg = 2: xz-corrector, theta = 0.250, beta = 0.500
	Put 38 free variables in a quadratic cone
	eqs m = 55, order n = 91, dim = 129, blocks = 3
	nnz(A) = 691 + 0, nnz(ADA) = 3025, nnz(L) = 1540
	 it :     b*y       gap    delta  rate   t/tP*  t/tD*   feas cg cg  prec
	  0 :            1.04E+00 0.000
	  1 :   4.42E+00 3.77E-01 0.000 0.3644 0.9000 0.9000  -0.29  1  1  2.7E+00
	  2 :   1.97E+00 1.63E-01 0.000 0.4313 0.9000 0.9000   2.66  1  1  6.7E-01
	  3 :   1.34E+00 6.54E-02 0.000 0.4016 0.9000 0.9000   2.97  1  1  1.3E-01
	  4 :   1.11E+00 2.11E-02 0.000 0.3232 0.9000 0.9000   1.39  1  1  4.4E-02
	  5 :   1.03E+00 7.22E-03 0.000 0.3416 0.9000 0.9000   0.09  1  1  5.6E-02
	  6 :   3.64E-01 5.78E-04 0.000 0.0801 0.9900 0.9900  -0.75  1  1  3.3E-02
	  7 :   8.22E-01 1.29E-05 0.000 0.0224 0.9900 0.9900  -1.00  1  1  2.7E-02
	  8 :   9.02E-02 1.37E-10 0.000 0.0000 1.0000 1.0000  -1.00  1  1  3.0E-02
	  9 :   9.02E-02 3.12E-14 0.000 0.0002 0.9999 0.9999  -1.00  1  1  3.5E-02
	
	Dual infeasible, primal improving direction found.
	iter seconds  |Ax|    [Ay]_+     |x|       |y|
	  9      0.1   1.9e-10   2.5e-11   4.5e+02   4.1e-11
	
	Detailed timing (sec)
	   Pre          IPM          Post
	1.640E-02    7.147E-02    6.809E-03    
	Max-norms: ||b||=1, ||c|| = 5,
	Cholesky |add|=0, |skip| = 0, ||L.L|| = 1.22198.
	Warning: Solver experienced issues: Infeasible problem (SeDuMi-1.3) 



