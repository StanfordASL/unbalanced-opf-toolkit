.. include:: substitutions.rst

Troubleshooting common problems
********************************

``savepath``
============
Sometimes when executing `savepath` in Ubuntu the following warning appears:

.. code-block:: none

	Warning: Unable to save path to file '/usr/local/MATLAB/R2019b/toolbox/local/pathdef.m'. You can save your path to a different
	location by calling SAVEPATH with an input argument that specifies the full path. For MATLAB to use that path in future
	sessions, save the path to 'pathdef.m' in your MATLAB startup folder. 

This can be fixed by running:

.. code-block:: bash

	sudo chown $USER /usr/local/MATLAB/R2019b/toolbox/local/pathdef.m


Calling |gld| from |matlab|
===========================
Sometimes when calling |gld| from |matlab|, the following error appears:

.. code-block:: none
	
	ERROR    [INIT] : gldcore/module.c(426): module 'powerflow' load failed - /usr/local/MATLAB/R2017b/sys/os/glnxa64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by /home/ubuntu/lib/gridlabd/powerflow.so)

To fix this problem, execute the following in a terminal:

.. code-block:: bash
	
	cd /usr/local/MATLAB/R2019b/sys/os/glnxa64

	sudo mv libstdc++.so.6 libstdc++.so.6.old

For more information, see `here <https://www.mathworks.com/matlabcentral/answers/329796-issue-with-libstdc-so-6>`_.

Sphinx documentation issues
===========================
* Sphinx aliases (e.g., ``longtext| replace:: this is a very very long text to include``) do not work when documenting keyword arguments in MATLAB code files



	

