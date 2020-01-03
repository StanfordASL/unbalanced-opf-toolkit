.. This rst was auto-generated from MATLAB code.
.. To make changes, update the MATLAB code and republish this document.

Debugging the power flow surrogate
---------------------------------------------------------------------------------------------------
We use :meth:`PowerFlowSurrogate_Bernstein2017_LP_3.AssignBaseCaseSolution` to debug the power flow surrogate.

*Generated from aaDebugPowerFlowSurrogate.m*    
    

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


Try to solve
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Problem is infeasible as we expected (see error message at the bottom)

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
	  9      0.0   1.9e-10   2.5e-11   4.5e+02   4.1e-11
	
	Detailed timing (sec)
	   Pre          IPM          Post
	9.706E-03    1.948E-02    1.841E-03    
	Max-norms: ||b||=1, ||c|| = 5,
	Cholesky |add|=0, |skip| = 0, ||L.L|| = 1.22198.
	Warning: Solver experienced issues: Infeasible problem (SeDuMi-1.3) 



Assign the base case solution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: matlab

	[U_array,T_array,p_pcc_array,q_pcc_array] = opf_problem.AssignBaseCaseSolution();


Check constraint satisfaction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The base case solution should be feasible. We can verify this by seeing if the constraints are fulfilled using YALMIP's check method (https://yalmip.github.io/command/check/). From this page, we see that "a solution is feasible if all residuals related to inequalities are non-negative."

.. code-block:: matlab

	constraint_array = opf_problem.GetConstraintArray();
	check(constraint_array)


.. code-block:: console  

	 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	|    ID|               Constraint|   Primal residual|                                            Tag|
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	|    #1|   Elementwise inequality|                 0|   charger_611_12: p_box_constraint lower bound|
	|    #2|   Elementwise inequality|                 0|   charger_611_12: q_box_constraint lower bound|
	|    #3|   Elementwise inequality|                 0|   charger_611_12: q_box_constraint upper bound|
	|    #4|   Elementwise inequality|                 0|    charger_632_2: p_box_constraint lower bound|
	|    #5|   Elementwise inequality|                 0|    charger_632_2: q_box_constraint lower bound|
	|    #6|   Elementwise inequality|                 0|    charger_632_2: q_box_constraint upper bound|
	|    #7|   Elementwise inequality|                 0|   charger_652_13: p_box_constraint lower bound|
	|    #8|   Elementwise inequality|                 0|   charger_652_13: q_box_constraint lower bound|
	|    #9|   Elementwise inequality|                 0|   charger_652_13: q_box_constraint upper bound|
	|   #10|   Elementwise inequality|                 0|    charger_675_9: p_box_constraint lower bound|
	|   #11|   Elementwise inequality|                 0|    charger_675_9: q_box_constraint lower bound|
	|   #12|   Elementwise inequality|                 0|    charger_675_9: q_box_constraint upper bound|
	|   #13|   Elementwise inequality|            1.0102|       swing_load: p_box_constraint lower bound|
	|   #14|   Elementwise inequality|            1.0316|            s_sum_mag_max_constraint swing_load|
	|   #15|      Equality constraint|                 0|                               u_pcc_constraint|
	|   #16|      Equality constraint|       -1.1102e-16|               voltage_magnitude_def_constraint|
	|   #17|   Elementwise inequality|          -0.04039|                   U_box_constraint lower bound|
	|   #18|   Elementwise inequality|           0.04794|                   U_box_constraint upper bound|
	|   #19|      Equality constraint|                 0|                         p_pcc_array_constraint|
	|   #20|      Equality constraint|                 0|                         q_pcc_array_constraint|
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 



Examine U_array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We see that "U_box_constraint lower bound" is clearly infeasible. Clearly, the constraint is violated since we set a minimal magnitude of 0.95 in GetExampleOPFproblem.

.. code-block:: matlab

	U_array


.. code-block:: console  

	
	U_array =
	
	    1.0625    1.0500    1.0687
	    0.9328    0.9998    0.9136
	    0.9328    0.9998    0.9136
	    0.9328    0.9998    0.9136
	    0.9266    1.0021    0.9117
	    0.9308       NaN    0.9116
	       NaN       NaN    0.9096
	    0.9624    0.9904    0.9518
	       NaN    0.9812    0.9499
	       NaN    0.9795    0.9479
	    0.9594    0.9885    0.9492
	    0.9357    0.9698    0.9305
	    0.9251       NaN       NaN
	



Examine U_array_ref
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We now examine what U_array is if we solve power flow for the base case exactly. We see that all voltages are above 0.95. In fact, some are even above 1.05 which is the maximal allowed voltage magnitude in our OPF problem. This suggests that the issue is that the power flow surrogate is not very accurate in this case.

.. code-block:: matlab

	[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = opf_problem.SolvePFbaseCase();
	U_array_ref


.. code-block:: console  

	
	U_array_ref =
	
	    1.0625    1.0500    1.0687
	    0.9899    1.0532    0.9774
	    0.9899    1.0532    0.9774
	    0.9899    1.0532    0.9774
	    0.9836    1.0554    0.9755
	    0.9879       NaN    0.9754
	       NaN       NaN    0.9734
	    1.0210    1.0422    1.0173
	       NaN    1.0332    1.0154
	       NaN    1.0316    1.0134
	    1.0180    1.0403    1.0147
	    0.9940    1.0220    0.9959
	    0.9821       NaN       NaN
	



Change linearization point
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
One way of increasing the accuracy is by bringing the linearization point closer to the operating conditions. Hence, we now linearize at the load in the first time step of the base case.

.. code-block:: matlab

	opf_problem.pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep;


Assign the new base case solution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We assign the base case solution again and examine U_array_2 It now matches U_array_ref exactly. This is not surprising since we are linearizing at precisely that operating point.

.. code-block:: matlab

	[U_array_2,T_array_2,p_pcc_array_2,q_pcc_array_2] = opf_problem.AssignBaseCaseSolution();
	U_array_2


.. code-block:: console  

	
	U_array_2 =
	
	    1.0625    1.0500    1.0687
	    0.9899    1.0532    0.9774
	    0.9899    1.0532    0.9774
	    0.9899    1.0532    0.9774
	    0.9836    1.0554    0.9755
	    0.9879       NaN    0.9754
	       NaN       NaN    0.9734
	    1.0210    1.0422    1.0173
	       NaN    1.0332    1.0154
	       NaN    1.0316    1.0134
	    1.0180    1.0403    1.0147
	    0.9940    1.0220    0.9959
	    0.9821       NaN       NaN
	



Check constraint satisfaction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We now see that U_box_constraint lower bound is feasible (i.e, has non-negative residual). We also notice that U_box_constraint upper bound is now infeasible. However, this is not a problem since we know that the exact solution has a few voltages above the upper limit of 1.05.

.. code-block:: matlab

	constraint_array = opf_problem.GetConstraintArray();
	check(constraint_array)


.. code-block:: console  

	 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	|    ID|               Constraint|   Primal residual|                                            Tag|
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	|    #1|   Elementwise inequality|                 0|   charger_611_12: p_box_constraint lower bound|
	|    #2|   Elementwise inequality|                 0|   charger_611_12: q_box_constraint lower bound|
	|    #3|   Elementwise inequality|                 0|   charger_611_12: q_box_constraint upper bound|
	|    #4|   Elementwise inequality|                 0|    charger_632_2: p_box_constraint lower bound|
	|    #5|   Elementwise inequality|                 0|    charger_632_2: q_box_constraint lower bound|
	|    #6|   Elementwise inequality|                 0|    charger_632_2: q_box_constraint upper bound|
	|    #7|   Elementwise inequality|                 0|   charger_652_13: p_box_constraint lower bound|
	|    #8|   Elementwise inequality|                 0|   charger_652_13: q_box_constraint lower bound|
	|    #9|   Elementwise inequality|                 0|   charger_652_13: q_box_constraint upper bound|
	|   #10|   Elementwise inequality|                 0|    charger_675_9: p_box_constraint lower bound|
	|   #11|   Elementwise inequality|                 0|    charger_675_9: q_box_constraint lower bound|
	|   #12|   Elementwise inequality|                 0|    charger_675_9: q_box_constraint upper bound|
	|   #13|   Elementwise inequality|           0.95731|       swing_load: p_box_constraint lower bound|
	|   #14|   Elementwise inequality|            1.0265|            s_sum_mag_max_constraint swing_load|
	|   #15|      Equality constraint|                 0|                               u_pcc_constraint|
	|   #16|      Equality constraint|                 0|               voltage_magnitude_def_constraint|
	|   #17|   Elementwise inequality|           0.02337|                   U_box_constraint lower bound|
	|   #18|   Elementwise inequality|        -0.0053805|                   U_box_constraint upper bound|
	|   #19|      Equality constraint|                 0|                         p_pcc_array_constraint|
	|   #20|      Equality constraint|                 0|                         q_pcc_array_constraint|
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 



Try to solve again
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
It works!

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
	  1 :   4.56E+00 3.80E-01 0.000 0.3665 0.9000 0.9000  -0.30  1  1  2.7E+00
	  2 :   2.04E+00 1.63E-01 0.000 0.4287 0.9000 0.9000   2.64  1  1  6.6E-01
	  3 :   1.42E+00 7.16E-02 0.000 0.4399 0.9000 0.9000   3.36  1  1  1.1E-01
	  4 :   1.14E+00 2.02E-02 0.000 0.2825 0.9000 0.9000   2.31  1  1  1.8E-02
	  5 :   1.11E+00 7.07E-03 0.000 0.3500 0.9000 0.9000   1.32  1  1  5.7E-03
	  6 :   1.11E+00 3.67E-03 0.000 0.5187 0.9000 0.9000   1.09  1  1  2.9E-03
	  7 :   1.10E+00 8.78E-04 0.000 0.2393 0.9000 0.9000   1.06  1  1  6.8E-04
	  8 :   1.10E+00 7.15E-05 0.000 0.0814 0.9900 0.9900   1.01  1  1  5.6E-05
	  9 :   1.10E+00 2.20E-06 0.000 0.0307 0.9900 0.9900   1.00  1  1  1.7E-06
	 10 :   1.10E+00 6.71E-08 0.000 0.0305 0.9900 0.9900   1.00  1  1  5.3E-08
	 11 :   1.10E+00 4.43E-09 0.000 0.0661 0.9900 0.9900   1.00  1  1  3.5E-09
	 12 :   1.10E+00 8.84E-10 0.000 0.1996 0.9000 0.9000   1.00  1  2  7.0E-10
	
	iter seconds digits       c*x               b*y
	 12      0.0   8.7  1.0964634360e+00  1.0964634338e+00
	|Ax-b| =   7.8e-10, [Ay-c]_+ =   6.9E-10, |x|=  3.6e+00, |y|=  8.2e+00
	
	Detailed timing (sec)
	   Pre          IPM          Post
	7.222E-03    2.418E-02    1.891E-03    
	Max-norms: ||b||=1, ||c|| = 5,
	Cholesky |add|=0, |skip| = 0, ||L.L|| = 6.80562.



