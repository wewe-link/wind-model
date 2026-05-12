pyHWM14
=======

Minimal Python interface for the HWM14 neutral wind model.

This repository intentionally ships prebuilt native extensions. The current
tree includes a Windows CPython 3.13 extension:

``pyhwm2014/hwm14.cp313-win_amd64.pyd``

For Linux with Python 3.10, the package needs a matching extension file:

``pyhwm2014/hwm14.cpython-310-x86_64-linux-gnu.so``

The Fortran build system and tests were removed. The package is meant for using
already compiled model binaries, not for rebuilding them during installation.

Requirements
------------

* Windows x64 with Python 3.13 and the bundled ``.pyd``
* Linux x86_64 with Python 3.10 and a bundled ``.so`` built for CPython 3.10
* ``uv`` or ``pip``

Installation
------------

With ``uv``:

.. code-block:: bash

    uv venv --python 3.10 --seed .venv
    uv pip install --python .venv/bin/python -e .

On Windows:

.. code-block:: powershell

    uv venv --python 3.13 --seed .venv
    uv pip install --python .venv\Scripts\python.exe -e .

With ``pip``:

.. code-block:: powershell

    python -m pip install -e .

Quick Demo
----------

.. code-block:: powershell

    .venv\Scripts\python.exe demo.py

Basic Usage
-----------

.. code-block:: python

    from pyhwm2014 import HWM14

    hwm = HWM14(
        alt=300.0,
        altlim=[300.0, 300.0],
        altstp=1,
        year=2023,
        day=150,
        ut=12.0,
        glat=40.0,
        glon=-105.0,
        ap=[-1, 10],
        option=1,
        verbose=False,
    )

    print(hwm.Uwind[0], hwm.Vwind[0])

Notes
-----

Native Python extensions are tied to both the operating system and the CPython
version. A Windows ``.pyd`` cannot be imported on Linux, and a CPython 3.13
extension cannot be imported by CPython 3.10. Add the matching prebuilt binary
to ``pyhwm2014/`` before installing on another platform.
