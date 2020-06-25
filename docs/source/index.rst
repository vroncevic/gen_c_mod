GEN_C_MOD
----------

.. toctree::
 :hidden:

 self

**gen_c_mod** is shell tool for generating C module.

Developed in `bash <https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_ code: **100%**.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/gen_c_mod.svg
   :target: https://github.com/vroncevic/gen_c_mod/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/gen_c_mod.svg
   :target: https://github.com/vroncevic/gen_c_mod/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/gen_c_mod/badge/?version=latest
   :target: https://gen_c_mod.readthedocs.io/projects/gen_c_mod/en/latest/?badge=latest

INSTALLATION
-------------

Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/gen_c_mod/releases

To install **gen_c_mod** type the following:

.. code-block:: bash

   tar xvzf gen_c_mod-x.y.z.tar.gz
   cd gen_c_mod-x.y.z
   cp -R ~/sh_tool/bin/   /root/scripts/gen_c_mod/ver.1.0/
   cp -R ~/sh_tool/conf/  /root/scripts/gen_c_mod/ver.1.0/
   cp -R ~/sh_tool/log/   /root/scripts/gen_c_mod/ver.1.0/

DEPENDENCIES
-------------

**gen_c_mod** requires next modules and libraries:
    sh_util `https://github.com/vroncevic/sh_util <https://github.com/vroncevic/sh_util>`_

SHELL TOOL STRUCTURE
---------------------

**gen_c_mod** is based on MOP.

Code structure:

.. code-block:: bash

   .
   ├── bin/
   │   └── gen_c_mod.sh
   ├── conf/
   │   ├── gen_c_mod.cfg
   │   ├── gen_c_mod_util.cfg
   │   └── template/
   │       ├── c_source.template
   │       └── h_header.template
   └── log/
       └── gen_c_mod.log

COPYRIGHT AND LICENCE
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2017 by `vroncevic.github.io/gen_c_mod <https://vroncevic.github.io/gen_c_mod>`_

This tool is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.
