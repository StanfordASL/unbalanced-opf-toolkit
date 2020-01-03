Getting Started
****************
The following sections will help you set up the environment and install |uot|.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

.. highlight:: matlab

.. include:: substitutions.rst

Prerequisites
==============

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   
YALMIP
--------------------------------------------

The code relies on `YALMIP <https://yalmip.github.io/>`_ to formulate and solve optimization problems. Before running the code make sure that YALMIP works and is able to solve linear (LPs) and semi-definite programs (SDPs) by running::

	yalmiptest

and verifying that the LP and SDP tests pass. 

Solvers
--------------------------------------------
Small problems can be solved using free solvers like GLPK and SeDuMi. 
However, large-scale problems benefit from a commercial solver. 
In our experience, Gurobi offers the best results, followed by MOSEK for LPs.
For SDPs, MOSEK is the best choice.
Both Gurobi and MOSEK offer free licenses for academia.
See `YALMIP’s solver page <https://yalmip.github.io/allsolvers/>`_ for more information.

At a minimum, you should install `Sedumi <https://github.com/SQLP/SeDuMi>`_ which is free and solves LPs and SDPs.

GridLAB-D
--------------------------------------------
Small networks can be defined directly in code (see GetLoadCaseIEEE_13_NoRegs_Manual.m). 
However, defining large models is time consuming and error prone
Hence, we support GridLAB-D models of power distribution networks.

To enable support of GridLAB-D models, you need to install ASL's `GridLAB-D fork <https://github.com/StanfordASL/gridlab-d>`_. 
See installation instructions there.

Environment
------------
You need to create a file ``src/main/aaSetEnvironment.m`` with environment specific configuration.
See ``src/main/aaSetEnvironmentTemplate.m`` for an example file.


Installation
==============

.. toctree::
   :maxdepth: 2
   :caption: Contents:

Clone the `unbalanced-opf-toolkit repository <https://github.com/StanfordASL/unbalanced-opf-toolkit>`_.

If you want to use UOT from outside the folder where it resides, you need to add this folder to MATLAB's path with the command::

	addpath('path to unbalanced-opf-toolkit')


For example::

	addpath('~/Repos/unbalanced-opf-toolkit')