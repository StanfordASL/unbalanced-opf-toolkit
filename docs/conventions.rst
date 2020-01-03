.. include:: substitutions.rst

Conventions
***********

File naming
===========
* Code files are named in UpperCamelCase with an initial capital
* Files that are meant to be executed directly start with aa. For example, ``aaSetEnvironment.m`` and ``aaUseCase_SolvePF.m``
* Function and class names are written in UpperCamelCase
* Variable names are generally lowercase (with some exceptions where uppercase is justified) and always separated with underscores
* Names for variables with units have the unit at the end. For example, ``time_step_s`` which is given in seconds. Throughout the code, we use base units (meter instead of kilometer, joule instead of kilo-watt-hour, watt instead of kilo-watt and so on)


Code conventions
================
Class constructors
------------------
We use ``nargin  > 0`` in class constructors to allow for no-argument constructor. This allows MATLAB to pre-allocate objects.


Class property validation
-------------------------
We validate class properties for type and number of elements whenever possible.


Validating number of elements for abstract classes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
In some cases, a property should have the type of an abstract class. 
For example, ``opf_problem`` in |uot.AbstractPowerFlowSurrogate| must be of type |uot.OPFproblem| which is abstract.
In this case, we cannot set the property validation to:: 

	opf_problem(1,1) uot.OPFproblem

because, since |uot.OPFproblem| cannot be instantiated directly, ``opf_problem`` will be empty when the object is created.

Instead, we use::

	opf_problem(:,:) uot.OPFproblem {uot.NumelMustBeLessThanOrEqual(1,opf_problem)}

which allows for ``opf_problem`` to be empty at creation and constraints it to have at most 1 element.