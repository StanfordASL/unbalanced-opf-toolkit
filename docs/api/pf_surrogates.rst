Power flow surrogates
=====================

.. include:: ../substitutions.rst

.. toctree::
   :maxdepth: 2
   :caption: Contents:

.. currentmodule:: +uot 

Fixed-point linear power flow model
-----------------------------------

|uot.PowerFlowSurrogateSpec_Bernstein2017_LP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogateSpec_Bernstein2017_LP

.. autoclass:: PowerFlowSurrogateSpec_Bernstein2017_LP
	:members:
	:show-inheritance:


|uot.PowerFlowSurrogate_Bernstein2017_LP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogate_Bernstein2017_LP

.. autoclass:: PowerFlowSurrogate_Bernstein2017_LP
	:members:
	:show-inheritance:

.. autofunction:: GetConstraintArray
.. autofunction:: SolveApproxPowerFlow
.. autofunction:: SolveApproxPowerFlowAlt

Protected
""""""""""
.. autofunction:: AssignBaseCaseSolution
.. autofunction:: ComputeVoltageEstimate

Private
""""""""""
.. autofunction:: ComputeMyMatrix
.. autofunction:: ComputeVoltageMagnitudeWithEq9
.. autofunction:: DefineDecisionVariables
.. autofunction:: GetLinearizationXy


Linearized power flow manifold model
--------------------------------------

|uot.PowerFlowSurrogateSpec_Bolognani2015_LP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogateSpec_Bolognani2015_LP

.. autoclass:: PowerFlowSurrogateSpec_Bolognani2015_LP
	:members:
	:show-inheritance:


|uot.PowerFlowSurrogate_Bolognani2015_LP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogate_Bolognani2015_LP

.. autoclass:: PowerFlowSurrogate_Bolognani2015_LP
	:members:
	:show-inheritance:

Linear branch flow model 
--------------------------------------

|uot.PowerFlowSurrogateSpec_Gan2014_LP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogateSpec_Gan2014_LP

.. autoclass:: PowerFlowSurrogateSpec_Gan2014_LP
	:members:
	:show-inheritance:

|uot.PowerFlowSurrogate_Gan2014_LP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogate_Gan2014_LP

.. autoclass:: PowerFlowSurrogate_Gan2014_LP
	:members:
	:show-inheritance:

Convex branch flow model 
--------------------------------------

|uot.PowerFlowSurrogateSpec_Gan2014_SDP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogateSpec_Gan2014_SDP

.. autoclass:: PowerFlowSurrogateSpec_Gan2014_SDP
	:members:
	:show-inheritance:

|uot.PowerFlowSurrogate_Gan2014_SDP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogate_Gan2014_SDP

.. autoclass:: PowerFlowSurrogate_Gan2014_SDP
	:members:
	:show-inheritance:

|uot.PowerFlowSurrogate_Gan2014|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@PowerFlowSurrogate_Gan2014

.. autoclass:: PowerFlowSurrogate_Gan2014
	:members:
	:show-inheritance:


Interface for power flow surrogates
-----------------------------------
|uot.AbstractPowerFlowSurrogateSpec|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@AbstractPowerFlowSurrogateSpec

.. autoclass:: AbstractPowerFlowSurrogateSpec
	:members:
	:show-inheritance:


|uot.AbstractPowerFlowSurrogate|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@AbstractPowerFlowSurrogate

.. autoclass:: AbstractPowerFlowSurrogate
	:members:
	:show-inheritance:

.. autofunction:: SolveApproxPowerFlowAlt