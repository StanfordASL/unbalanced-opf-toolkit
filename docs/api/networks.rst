Power networks
==============

.. include:: ../substitutions.rst

.. toctree::
   :maxdepth: 2
   :caption: Contents:

Networks
--------
|uot.Network_Unbalanced|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@Network_Unbalanced

.. autoclass:: Network_Unbalanced
	:members:
	:show-inheritance:

|uot.Network_Prunned|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@Network_Prunned

.. autoclass:: Network_Prunned
	:members:
	:show-inheritance:

|uot.Network_Splitphased|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@Network_Splitphased

.. autoclass:: Network_Splitphased
	:members:
	:show-inheritance:

.. autofunction:: CreateNetworkWithPrunedSecondaries


|uot.AbstractNetwork|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@AbstractNetwork

.. autoclass:: AbstractNetwork
	:members:
	:show-inheritance:

.. autofunction:: ComputeCurrentInjectionFromVoltage
.. autofunction:: ComputeLinkCurrentsAndPowers
.. autofunction:: ComputePowerInjectionFromVoltage

Buses
------
|uot.BusSpec_Unbalanced|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@BusSpec_Unbalanced

.. autoclass:: BusSpec_Unbalanced
	:members:
	:show-inheritance:
	
|uot.BusSpec_Splitphased|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@BusSpec_Splitphased

.. autoclass:: BusSpec_Splitphased
	:members:
	:show-inheritance:


Interfaces
----------
|uot.AbstractLinkSpec|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@AbstractLinkSpec

.. autoclass:: AbstractLinkSpec
	:members:
	:show-inheritance:

|uot.AbstractBusSpec|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: main.+uot.@AbstractBusSpec

.. autoclass:: AbstractBusSpec
	:members:
	:show-inheritance:

