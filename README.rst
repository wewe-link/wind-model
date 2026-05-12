pyHWM14
=======

Minimal Windows Python interface for the HWM14 neutral wind model.

This repository ships a prebuilt native extension for 64-bit Windows:

* ``pyhwm2014/hwm14.cp310-win_amd64.pyd`` for CPython 3.10

The Fortran build system and tests were removed. The package is meant for using
already compiled model binaries, not for rebuilding them during installation.

Requirements
------------

* Windows x64
* Python 3.10
* ``uv`` or ``pip``

Installation
------------

With ``uv``:

.. code-block:: powershell

    uv venv --python 3.10 --seed .venv
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

Native Python extensions are tied to the operating system and CPython version.
This package currently bundles a binary for Windows CPython 3.10 only.
