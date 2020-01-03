Optimal power flow problems
===========================
.. include:: ../substitutions.rst

.. currentmodule:: main.+uot 


Optimal power flow problems are comprised of the following elements

* Network
* Load case
* Power flow surrogate
* Optimization objective
* Controllable loads
* Specification of voltage at |pcc|
* Constraints on voltage magnitude
* (Optional) additional constraints (e.g., on the |pcc| load or line currents)

As is common for the Toolkit, there is a class to specify the problem :class:`@OPFspec.OPFspec` and one for the actual problem :class:`@OPFproblem.OPFproblem`.


|uot.OPFspec|: Specify OPF problems
---------------------------------------
.. automodule:: main.+uot.@OPFspec

.. autoclass:: OPFspec
	:members:
	:show-inheritance:


|uot.OPFproblem|: Solve OPF problems
---------------------------------------
.. automodule:: main.+uot.@OPFproblem

.. autoclass:: OPFproblem
	:members:
	:show-inheritance:

.. autofunction:: AssertConstraintSatisfaction
.. autofunction:: AssignBaseCaseSolution
.. autofunction:: EvaluatePowerInjectionFromPCCload
.. autofunction:: GetConstraintArray


.. autofunction:: AssignControllableLoadsToNoLoad
.. autofunction:: ComputeNodalPowerInjection
.. autofunction:: CreateControllableLoadHashTable
.. autofunction:: CreateLoadSpecArrayWithControllableLoadValues
.. autofunction:: DefineObjective_LoadCost
.. autofunction:: GetControllableLoadConstraintArray


Interfaces
----------
|uot.ConstraintProvider|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@ConstraintProvider

.. autoclass:: ConstraintProvider
	:members:
	:show-inheritance:
