.. This rst was auto-generated from MATLAB code.
.. To make changes, update the MATLAB code and republish this document.

Solve optimal power flow problem
---------------------------------------------------------------------------------------------------
We solve an optimal power flow problem using UOT.

*Generated from aaUseCase_SolveOPF.m*    
    

.. code-block:: matlab

	clear variables
	aaSetupPath
	
	% If true, use GridLAB-D to get the power network model
	use_gridlab = false;


Initialize OPF problem
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We use the power flow surrogate BFM SDP from Gan2014

.. code-block:: matlab

	pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_SDP();
	opf_problem = GetExampleOPFproblem(pf_surrogate_spec,use_gridlab);
	
	% Select solver
	opf_problem.sdpsettings = sdpsettings('solver','sedumi');


Solve OPF problem
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Solve optimization problem

.. code-block:: matlab

	[objective_value,solver_time,diagnostics] = opf_problem.Solve();
	
	% Estimate voltage from result of optimization problem
	[U_array,T_array]= opf_problem.GetVoltageEstimate();


.. code-block:: console  

	SeDuMi 1.32 by AdvOL, 2005-2008 and Jos F. Sturm, 1998-2003.
	Alg = 2: xz-corrector, theta = 0.250, beta = 0.500
	Put 234 free variables in a quadratic cone
	eqs m = 340, order n = 207, dim = 1557, blocks = 15
	nnz(A) = 3135 + 0, nnz(ADA) = 115600, nnz(L) = 57970
	 it :     b*y       gap    delta  rate   t/tP*  t/tD*   feas cg cg  prec
	  0 :            9.44E-01 0.000
	  1 :   1.18E+01 5.67E-01 0.000 0.6007 0.9000 0.9000   1.68  1  1  6.8E+00
	  2 :  -1.63E+00 2.65E-01 0.000 0.4675 0.9000 0.9000   2.49  1  1  3.2E+00
	  3 :   4.61E-01 1.26E-01 0.000 0.4744 0.9000 0.9000   1.32  1  1  1.2E+00
	  4 :   8.07E-01 4.93E-02 0.000 0.3919 0.9000 0.9000   1.97  1  1  3.1E-01
	  5 :   9.13E-01 2.17E-02 0.000 0.4404 0.9000 0.9000   1.94  1  1  9.6E-02
	  6 :   9.86E-01 7.47E-03 0.000 0.3439 0.9000 0.9000   1.42  1  1  2.7E-02
	  7 :   1.02E+00 2.37E-03 0.000 0.3180 0.9000 0.9000   1.20  1  1  7.9E-03
	  8 :   1.04E+00 4.71E-04 0.000 0.1985 0.9000 0.9000   1.07  1  1  1.5E-03
	  9 :   1.04E+00 9.96E-05 0.000 0.2112 0.9000 0.9000   1.02  1  1  3.2E-04
	 10 :   1.04E+00 2.18E-05 0.000 0.2191 0.9000 0.9000   1.01  1  1  6.9E-05
	 11 :   1.04E+00 4.69E-06 0.000 0.2149 0.9000 0.9000   1.02  1  1  1.5E-05
	 12 :   1.04E+00 9.78E-07 0.000 0.2086 0.9000 0.9000   1.02  1  1  3.0E-06
	 13 :   1.04E+00 1.98E-07 0.000 0.2028 0.9000 0.9000   1.01  1  1  6.1E-07
	 14 :   1.04E+00 3.93E-08 0.000 0.1984 0.9000 0.9000   1.00  2  2  1.2E-07
	 15 :   1.04E+00 7.64E-09 0.000 0.1943 0.9000 0.9000   1.00  2  2  2.3E-08
	 16 :   1.04E+00 1.49E-09 0.000 0.1949 0.9000 0.9000   1.00  2  2  4.6E-09
	 17 :   1.04E+00 3.12E-10 0.000 0.2096 0.9000 0.9000   1.00  2  2  9.6E-10
	
	iter seconds digits       c*x               b*y
	 17      0.6   8.8  1.0417424945e+00  1.0417424930e+00
	|Ax-b| =   1.9e-09, [Ay-c]_+ =   3.0E-10, |x|=  1.1e+01, |y|=  1.3e+01
	
	Detailed timing (sec)
	   Pre          IPM          Post
	8.772E-02    5.089E-01    2.397E-02    
	Max-norms: ||b||=1, ||c|| = 5,
	Cholesky |add|=0, |skip| = 0, ||L.L|| = 41661.5.



Verify if the solution is exact
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Compare the indirect variables (voltages at non-PCC buses and power injection at PCC) from the optimization problem and the power flow solution. If they match, then the solution is exact.

.. code-block:: matlab

	% Solve power flow using the controllable loads computed in the optimization
	[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = opf_problem.SolvePFwithControllableLoadValues();
	
	% Convert polar representation to complex
	V_array = uot.PolarToComplex(U_array,T_array);
	V_array_ref = uot.PolarToComplex(U_array_ref,T_array_ref);
	
	% Compare voltages at non-PCC buses
	V_array_error = abs(V_array - V_array_ref);
	V_array_error_max = max(V_array_error(:))
	
	% Compare power injection at PCC
	[p_pcc_array,q_pcc_array] = opf_problem.EvaluatePowerInjectionFromPCCload();
	s_pcc_array = p_pcc_array + 1i*q_pcc_array;
	s_pcc_array_ref = p_pcc_array_ref + 1i*q_pcc_array_ref;
	
	s_pcc_array_ref_error = abs(s_pcc_array - s_pcc_array_ref);
	
	s_pcc_array_ref_error_max = max(s_pcc_array_ref_error(:))


.. code-block:: console  

	
	V_array_error_max =
	
	   6.1412e-10
	
	
	s_pcc_array_ref_error_max =
	
	   1.9129e-09
	



