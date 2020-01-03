.. highlight:: matlab
.. include:: ../../substitutions.rst

Implement a new power flow surrogate
=======================================
This tutorial shows how to implement a new power flow surrogate based on :cite:`Bernstein2017`.

The purpose of a power flow surrogate is to relate direct variables (voltage at |pcc| and power injections at PQ buses) to indirect variables (power injection at |pcc| and voltage at PQ buses). 
Concretely, the power flow surrogate needs to implement the following constraints:

- Voltage magnitude limits
- Power injection at |pcc|

In addition, the surrogate needs to specify the voltage at |pcc|. 
At first, this might seem surprising since the voltage at |pcc| is a direct variable.
However, recall that different surrogates represent voltage in different ways.
For example:

- |uot.PowerFlowSurrogate_Gan2014_SDP| uses one hermitian matrix per bus
- |uot.PowerFlowSurrogate_Bolognani2015_LP| uses one real vector for voltage magnitude and another for voltage phase

This means, the implementation of the voltage at |pcc| constraint is different in each case. 
Consequently, |uot| leaves the implementation of the constraint to each surrogate.

The opposite happens for the power injection at the |pcc|: it is an indirect variable but the constraints on it are implemented by |uot.ControllableLoad| and not by the surrogate. 
The reason is that the |pcc| load is always represented in the same way: one real vector for active power injection and another for reactive power injection.
Since the constraints always take the same form, it makes sense to implement them only once.

One important remark is in order: the |pcc| load is implemented in |uot.OPFproblem| but the power flow surrogate *must* couple it to the rest of the problem through a constraint. This is typically done through::

	[P_inj_array,Q_inj_array] = obj.opf_problem.ComputeNodalPowerInjection();

For an example, see :meth:`uot.PowerflowSurrogate_Bolognani2015_LP.GetConstraintArray<main.+uot.@PowerflowSurrogate_Bolognani2015_LP.GetConstraintArray>`.

Power flow surrogate specification
---------------------------------------------
The first step is creating :class:`PowerFlowSurrogateSpec_Bernstein2017_LP_1` which is a derived class of |uot.AbstractPowerFlowSurrogateSpec|. 
A good starting point is making a copy of |uot.SpecTemplate| and changing the parent class to |uot.AbstractPowerFlowSurrogateSpec|.
By convention, we put the class in a directory named @PowerFlowSurrogateSpec_Bernstein2017_LP_1.
This is not strictly necessary but makes it easier to see if a file is a class, function or script.
For now, we can leave the sample documentation as it is.

Looking at |uot.AbstractPowerFlowSurrogateSpec|, we learn that the purpose of :class:`PowerFlowSurrogateSpec_Bernstein2017_LP_1` is simply telling |uot.OPFproblem| how to instantiate the power flow surrogate. 
For this purpose, we need to create a concrete implementation of :meth:`uot.AbstractPowerFlowSurrogateSpec.Create<main.+uot.@AbstractPowerFlowSurrogateSpec.AbstractPowerFlowSurrogateSpec.Create>`.
For inspiration, we can look how this is done in |uot.PowerFlowSurrogateSpec_Bolognani2015_LP|.

At the end, we have:


.. literalinclude:: ../../../src/demo/PowerFlowSurrogateTutorial/@PowerFlowSurrogateSpec_Bernstein2017_LP_1/PowerFlowSurrogateSpec_Bernstein2017_LP_1.m
   :language: matlab
   :linenos:


.. note:: 
	We add the suffix `_1` to distinguish this first implementation from more evolved ones we will develop in the course of the tutorial.

.. note:: 
	The classes created in this tutorial are not prefixed by `uot`, since they are not in the +uot directory which builds the module.
	The production implementation (which is preceded by uot) are optimized for performance and include further functionality which is outside the scope of this tutorial


Barebones power flow surrogate
------------------------------
The next step is creating a barebones power flow surrogate class which is derived of |uot.AbstractPowerFlowSurrogate|. 

Looking at |uot.AbstractPowerFlowSurrogate|, we see that we need to implement some abstract methods:

- :meth:`AssignBaseCaseSolution`
- :meth:`ComputeVoltageEstimate`
- :meth:`GetConstraintArray`
- :meth:`SolveApproxPowerFlow` |static|


We now create the class :class:`PowerFlowSurrogateSpec_Bernstein2017_LP_1` with these methods as stubs. 
A good starting point is making a copy of |uot.ObjectTemplate| and changing the parent class to |uot.AbstractPowerFlowSurrogate|.
For now, we can leave the sample documentation as it is.

We implement the constructor following the example of |uot.PowerFlowSurrogate_Bolognani2015_LP|.
At the end, we have the barebones implementation:

.. literalinclude:: ../../../src/demo/PowerFlowSurrogateTutorial/@PowerFlowSurrogate_Bernstein2017_LP_1/PowerFlowSurrogate_Bernstein2017_LP_1.m
   :language: matlab
   :linenos:


.. include:: aaInstantiateBarebones.rst

.. note:: 
	By convention, we use the prefix `aa` in scripts to distinguish them from functions

Solving approximate power flow
-------------------------------
Implementing power flow surrogates is tricky and error-prone. 
Hence, testing is an integral part of the process. 
One sensible way of doing this is trying to replicate the results in the paper. 

The paper presents a *continuation analysis* where they approximately solve power flow for a series of scaled loads using the proposed linear formulation. 
Then, they compare the results with the actual power flow solution and compute the error.

We will try to replicate the results in Figures 3 and 5 of the paper.
Figure 3 shows an error of less than 0.2% in voltage whereas Figure 5 shows an error of less than 1.5% for the power at the |pcc|.

In order to replicate the paper's results, we need to solve *power flow* and not *optimal power flow*. 
It is very common that power flow surrogates offer a way of approximately solving power flow algebraically.
In fact, Bernstein's paper is not about |opf| at all. 
The method :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowAlt<main.+uot.@AbstractPowerFlowSurrogate.AbstractPowerFlowSurrogate.SolveApproxPowerFlowAlt>` exists precisely for this use case.
It can be overridden by a power flow surrogate to offer a way of solving power flow.

.. note:: 
	The Alt in `SolveApproxPowerFlowAlt` is there because :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlow<main.+uot.@AbstractPowerFlowSurrogate.AbstractPowerFlowSurrogate.SolveApproxPowerFlow>` also exists. 
	However, `SolveApproxPowerFlow` uses a different method that requires solving an optimization problem.
	The advantage of the optimization-based method is that it works even for surrogates where power flow cannot be solved in an algebraic fashion (e.g., |uot.PowerFlowSurrogate_Gan2014_SDP|)


For this purpose, we implement  :meth:`PowerFlowSurrogate_Bernstein2017_LP_2.SolveApproxPowerFlowAlt`:

.. literalinclude:: ../../../src/demo/PowerFlowSurrogateTutorial/@PowerFlowSurrogate_Bernstein2017_LP_2/SolveApproxPowerFlowAlt.m
	:language: matlab
	:linenos:


.. include:: aaReplicatePaperResults.rst

Creating an initial test case
-------------------------------
We managed to replicate the results of the paper giving us trust in the correctness of our implementation. 
The next step is to make a functional test case out of this experiment. 
The starting point for this is :func:`SampleTest`.

As before, we can take inspiration from other power flow surrogates, for example, :func:`PowerFlowSurrogate_Bolognani2015_LPtest` for inspiration. 
This file has two test cases (i.e., functions starting with Test): :func:`TestAgainstPaper` and :func:`TestPowerFlowSurrogate_Bolognani2015_LP`.
:func:`TestAgainstPaper` compares the results of the |uot| implementation with code published by the paper's authors. 
This test is rooted on :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt>`.

:func:`PowerFlowSurrogate_Bolognani2015_LP` then verifies that the result of solving an |opf| problem are consistent with :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt>`.
Furthermore, it verifies that constraints of the |opf| problem are satisfied.

Now, we create a test case analogous to  `TestAgainstPaper` based on our previous results: 

.. literalinclude:: ../../../src/demo/PowerFlowSurrogateTutorial/PowerFlowSurrogate_Bernstein2017_LP_2test.m
   :language: matlab
   :linenos:


Implementing the power flow surrogate
-------------------------------------
Finally, we get to the implementation of the actual surrogate.
For this purpose, we need to implement the following methods:

- :meth:`GetConstraintArrayHelper`
- :meth:`DefineDecisionVariables`

Let's get started with :meth:`GetConstraintArrayHelper`, which defines the constraints we need to implement. 
From above, we know these are:

- Voltage at |pcc|
- Voltage magnitude limits
- Power injection at |pcc|

Again, we can use :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.GetConstraintArrayHelper<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.GetConstraintArrayHelper>` for guidance. 
Furthermore, we can use much of the code that we wrote for :meth:`PowerFlowSurrogate_Bernstein2017_LP_2.SolveApproxPowerFlowAlt`.
In order to reduce code duplication we will be moving some of the code there into new methods.
We just need to keep in mind that these methods must be static so that  :meth:`PowerFlowSurrogate_Bernstein2017_LP_3.SolveApproxPowerFlowAlt` (which is static) can call them.

.. literalinclude:: ../../../src/demo/PowerFlowSurrogateTutorial/@PowerFlowSurrogate_Bernstein2017_LP_3/GetConstraintArray.m
   :language: matlab
   :linenos:

.. Trying out the power flow surrogate
.. ------------------------------------

.. include:: aaSolveOPF.rst



Preparation for debugging the power flow surrogate
--------------------------------------------------
One good approach for debugging problems is to set the decision variables
to the base case solution (i.e., when all controllable loads are zero).
In most OPF problems this is a feasible solution, albeit a non-optimal one.
This debugging process has been so helpful in the past that there is an
abstract method just for this purpose: :meth:`AssignBaseCaseSolution`.

We now implement :meth:`PowerFlowSurrogate_Bernstein2017_LP_3.AssignBaseCaseSolution`. 
Once again, we use :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.AssignBaseCaseSolution<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.AssignBaseCaseSolution>` for inspiration.

.. literalinclude:: ../../../src/demo/PowerFlowSurrogateTutorial/@PowerFlowSurrogate_Bernstein2017_LP_3/AssignBaseCaseSolution.m
   :language: matlab
   :linenos:


.. Debugging the power flow surrogate
.. ------------------------------------

.. include:: aaDebugPowerFlowSurrogate.rst


Improving the test case
-----------------------
When we examined :func:`PowerFlowSurrogate_Bolognani2015_LPtest` in `Creating an initial test case`_ we saw that it included two test cases: :func:`TestAgainstPaper` and :func:`TestPowerFlowSurrogate_Bolognani2015_LP`.
Earlier, we implemented the equivalent to :func:`TestAgainstPaper` for the power flow surrogate we are developing. 
Now, we implement the equivalent to :func:`TestPowerFlowSurrogate_Bolognani2015_LP`.

In the case of :func:`PowerFlowSurrogate_Bolognani2015_LPtest`, :func:`TestPowerFlowSurrogate_Bolognani2015_LP` calls a helper function :func:`SolutionFulfillsLinearPowerFlowAndConstraints` which first solves the OPF problem and then creates a load case which includes the values of the controllable loads in the optimal solution. 
Finally, it calls :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt>` using this load case.

The test :func:`TestAgainstPaper` gives us confidence that :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt>` is correct.
In light of this, :func:`PowerFlowSurrogate_Bolognani2015_LPtest` then verifies that the decision variables in the optimization take values that are consistent with :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlowAlt>`.
Then, it calls :meth:`uot.OPFproblem.AssertConstraintSatisfaction<main.+uot.@OPFproblem.AssertConstraintSatisfaction>` which verifies that the decision variables in the OPF problem fulfill the specified constraints.
This ensures that we did not forget to implement any constraints in the powerflow surrogate.

.. note::
	By using a power flow surrogate we make the OPF problem tractable. 
	However, we pay a price for this: we lose exact knowledge of the indirect variables (see :cite:`Estandia2018` for a more detailed explanation).  
	This means that having the decision variables in the OPF problem fulfill the specified constraints (which is what we verify in the test), does not guarantee that the constraints will be fulfilled if we solve the power flow equations using the values for the controllable loads.
	This difference becomes clear with the following code for a generic OPF problem

	.. code-block:: matlab

		[objective_value,solver_time,diagnostics] = opf_problem.Solve();

		% These are the values from the decision variables in the optimization problem
		[U_array,T_array] = opf_problem.GetVoltageEstimate();
		[p_pcc_array,q_pcc_array] = opf_problem.EvaluatePowerInjectionFromPCCload();

		% These are the result of solving the power flow equations with the
		% values of the controllable loads computed in the optimization
		[U_array_pf,T_array_pf,p_pcc_array_pf,q_pcc_array_pf] = opf_problem.SolvePFwithControllableLoadValues();

		% In general, U_array will not match U_array_pf, T_array will not match T_array_pf
		% and so on.


Now, we go back to implementing our test case following the example of :func:`PowerFlowSurrogate_Bolognani2015_LPtest`.

.. literalinclude:: ../../../src/demo/PowerFlowSurrogateTutorial/PowerFlowSurrogate_Bernstein2017_LP_3test.m
   :language: matlab
   :linenos:

Wrapping up the implementation
------------------------------
We have implemented almost all the abstract methods mentioned in `Barebones power flow surrogate`_. 
We are only missing :meth:`PowerFlowSurrogate_Bernstein2017_LP_3.SolveApproxPowerFlow`.
Looking at :meth:`uot.PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlow<main.+uot.@PowerFlowSurrogate_Bolognani2015_LP.SolveApproxPowerFlow>`, we can see that the method is really simple.
It only tells :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper<main.+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper>` what power flow spec to use.
We go ahead and implement it.


Documentation
-------------
Documentation is key to make the code understandable for new users or for yourself after a few months have passed. 
As always, writing self-documenting code is a great starting point.
However, it is typically very useful to have a header describing the code's behavior.
The Unbalanced OPF Toolkit uses Sphynx and the MATLAB domain for documentation.

The documentation of code is based on headers which are writing using a particular format, see :ref:`documentation_templates`. 
Then, the files must be added to an ``rst`` file as we will do here.

The reStructuredText markup and resulting output are below.

reStructuredText markup
^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: rst

	.. Add substitutions for this tutorial
	.. |PowerFlowSurrogateSpec_Bernstein2017_LP_3| replace:: :class:`PowerFlowSurrogateSpec_Bernstein2017_LP_3<demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogateSpec_Bernstein2017_LP_3.PowerFlowSurrogateSpec_Bernstein2017_LP_3>`
	.. |PowerFlowSurrogate_Bernstein2017_LP_3| replace:: :class:`PowerFlowSurrogate_Bernstein2017_LP_3<demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogate_Bernstein2017_LP_3.PowerFlowSurrogate_Bernstein2017_LP_3>`


	|PowerFlowSurrogateSpec_Bernstein2017_LP_3|
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	.. automodule:: demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogateSpec_Bernstein2017_LP_3

	.. autoclass:: PowerFlowSurrogateSpec_Bernstein2017_LP_3
		:members:
		:show-inheritance:


	|PowerFlowSurrogate_Bernstein2017_LP_3|
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	.. automodule:: demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogate_Bernstein2017_LP_3

	.. autoclass:: PowerFlowSurrogate_Bernstein2017_LP_3
		:members:
		:show-inheritance:

	.. autofunction:: GetLinearizationVoltage
	.. autofunction:: SolveApproxPowerFlow
	.. autofunction:: SolveApproxPowerFlowAlt

	Protected
	""""""""""
	.. autofunction:: AssignBaseCaseSolution
	.. autofunction:: ComputeVoltageEstimate
	.. autofunction:: GetConstraintArray

	Private
	""""""""""
	.. autofunction:: ComputeMyMatrix
	.. autofunction:: ComputeVoltageMagnitudeWithEq9
	.. autofunction:: DefineDecisionVariables
	.. autofunction:: GetLinearizationXy


	PowerFlowSurrogate_Bernstein2017_LP_3test
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	.. autofunction:: demo.PowerFlowSurrogateTutorial.PowerFlowSurrogate_Bernstein2017_LP_3test


.. Add substitutions for this tutorial
.. |PowerFlowSurrogateSpec_Bernstein2017_LP_3| replace:: :class:`PowerFlowSurrogateSpec_Bernstein2017_LP_3<demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogateSpec_Bernstein2017_LP_3.PowerFlowSurrogateSpec_Bernstein2017_LP_3>`
.. |PowerFlowSurrogate_Bernstein2017_LP_3| replace:: :class:`PowerFlowSurrogate_Bernstein2017_LP_3<demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogate_Bernstein2017_LP_3.PowerFlowSurrogate_Bernstein2017_LP_3>`


|PowerFlowSurrogateSpec_Bernstein2017_LP_3|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogateSpec_Bernstein2017_LP_3

.. autoclass:: PowerFlowSurrogateSpec_Bernstein2017_LP_3
	:members:
	:show-inheritance:


|PowerFlowSurrogate_Bernstein2017_LP_3|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: demo.PowerFlowSurrogateTutorial.@PowerFlowSurrogate_Bernstein2017_LP_3

.. autoclass:: PowerFlowSurrogate_Bernstein2017_LP_3
	:members:
	:show-inheritance:

.. autofunction:: GetLinearizationVoltage
.. autofunction:: SolveApproxPowerFlow
.. autofunction:: SolveApproxPowerFlowAlt

Protected
""""""""""
.. autofunction:: AssignBaseCaseSolution
.. autofunction:: ComputeVoltageEstimate
.. autofunction:: GetConstraintArray

Private
""""""""""
.. autofunction:: ComputeMyMatrix
.. autofunction:: ComputeVoltageMagnitudeWithEq9
.. autofunction:: DefineDecisionVariables
.. autofunction:: GetLinearizationXy


PowerFlowSurrogate_Bernstein2017_LP_3test
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. autofunction:: demo.PowerFlowSurrogateTutorial.PowerFlowSurrogate_Bernstein2017_LP_3test




















