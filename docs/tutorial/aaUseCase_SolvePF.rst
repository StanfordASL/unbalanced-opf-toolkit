.. This rst was auto-generated from MATLAB code.
.. To make changes, update the MATLAB code and republish this document.

Solve power flow problem
---------------------------------------------------------------------------------------------------
We solve a power flow problem using UOT's solver.

*Generated from aaUseCase_SolvePF.m*    
    

.. code-block:: matlab

	clear variables
	aaSetupPath
	
	% If true, use GridLAB-D to get the power network model
	use_gridlab = false;


Initialize network and loads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Create a LoadCase object which includes the network and loads. Also define the voltage at the PCC bus.

.. code-block:: matlab

	% Get load case and voltage at PCC
	if use_gridlab
	    model_importer = GetModelImporterIEEE_13_NoRegs();
	    model_importer.Initialize();
	
	    load_case = model_importer.load_case_prerot;
	
	    u_pcc_array = model_importer.u_pcc_array;
	    t_pcc_array = model_importer.t_pcc_array;
	else
	    load_case = GetLoadCaseIEEE_13_NoRegs_Manual();
	
	    u_pcc_array = [1, 1, 1];
	    t_pcc_array = deg2rad([0, -120, 120]);
	end


Solve power flow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Solve power flow with UOT's solver.

.. code-block:: matlab

	[U_array,T_array,p_pcc_array,q_pcc_array] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);
	
	U_array


.. code-block:: console  

	
	U_array =
	
	    1.0000    1.0000    1.0000
	    0.9227    1.0017    0.8995
	    0.9227    1.0017    0.8995
	    0.9227    1.0017    0.8995
	    0.9155    1.0041    0.8972
	    0.9209       NaN    0.8974
	       NaN       NaN    0.8953
	    0.9557    0.9910    0.9438
	       NaN    0.9817    0.9421
	       NaN    0.9800    0.9402
	    0.9524    0.9891    0.9410
	    0.9267    0.9697    0.9206
	    0.9157       NaN       NaN
	



