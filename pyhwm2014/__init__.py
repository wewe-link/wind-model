"""Python interface for HWM14 (Horizontal Wind Model 2014).

This package provides a Python interface to the HWM14 model for calculating
atmospheric wind speeds at various geophysical locations and conditions.
"""

import os
import sys
from pathlib import Path


def _configure_windows_dll_search_path() -> None:
    """Make f2py-built extension dependencies discoverable on Windows."""
    if sys.platform != "win32" or not hasattr(os, "add_dll_directory"):
        return

    package_dir = Path(__file__).resolve().parent
    candidates = [str(package_dir), sys.base_prefix, sys.prefix]
    candidates.extend(os.environ.get("PATH", "").split(os.pathsep))

    # MinGW-w64 wheels/extensions commonly link against UCRT "downlevel" API
    # DLLs and MSYS2 runtime DLLs when built locally on Windows.
    candidates.extend(
        [
            r"C:\Windows\System32\downlevel",
            r"C:\msys64\ucrt64\bin",
            r"C:\msys64\mingw64\bin",
        ]
    )

    seen: set[str] = set()
    for path in candidates:
        if not path:
            continue
        normalized = os.path.normcase(os.path.abspath(path))
        if normalized in seen or not os.path.isdir(path):
            continue
        seen.add(normalized)
        try:
            os.add_dll_directory(path)
        except OSError:
            pass


_configure_windows_dll_search_path()

from .data import HWMPATH
from .core import HWM14, HWM142D, hwm14_vectorized

__all__ = ["HWM14", "HWM142D", "HWMPATH", "hwm14_vectorized"]

from importlib.metadata import PackageNotFoundError, version

try:
    __version__ = version("pyhwm2014")
except PackageNotFoundError:
    __version__ = "0.0.0"
