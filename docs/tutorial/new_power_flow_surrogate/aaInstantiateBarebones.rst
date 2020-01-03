.. This rst was auto-generated from MATLAB code.
.. To make changes, update the MATLAB code and republish this document.

Initialize OPF problem with PowerFlowSurrogateSpec_Bernstein2017_LP_1
---------------------------------------------------------------------------------------------------
Here, we instantiate OPF problem with PowerFlowSurrogateSpec_Bernstein2017_LP_1 to verify that out barebones implementation is working as expected.

*Generated from aaInstantiateBarebones.m*    
    
.. code-block:: matlab

	clear variables
	
	aaSetupPath
	
	[opf_spec, load_case] = CreateSampleOPFspec();
	
	% Replace pf_surrogate_spec with PowerFlowSurrogateSpec_Bernstein2017_LP_1
	opf_spec.pf_surrogate_spec = PowerFlowSurrogateSpec_Bernstein2017_LP_1();
	
	opf_problem = uot.OPFproblem(opf_spec,load_case);


