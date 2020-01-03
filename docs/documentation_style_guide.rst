.. include:: substitutions.rst

Documentation style guide
*******************************

Sphinx Matlab Domain
====================
The code is documented using `Sphinx Matlab Domain <https://github.com/sphinx-contrib/matlabdomain>`_. 
To build the documentation, cd to ``docs``  and run

.. code-block:: bash

	make html


Then open ``docs/_build/index.html`` with a browser.


Title formatting
================
Use the following punctuation characters in the section titles:

*  ``*`` for Chapters
*  ``=`` for sections ("Heading 1")
*  ``-`` for subsections ("Heading 2")
*  ``^`` for subsubsections ("Heading 3")
*  ``"`` for paragraphs ("Heading 4")


.. _documentation_templates:

Templates
======================
Object template
----------------
.. automodule:: main.+uot.@ObjectTemplate

.. autoclass:: ObjectTemplate
	:members:
	:show-inheritance:


Spec template
----------------
.. automodule:: main.+uot.@SpecTemplate

.. autoclass:: SpecTemplate
	:members:
	:show-inheritance: