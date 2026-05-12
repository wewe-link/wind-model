# Building pyhwm2014

This document explains how to build Python extensions for pyhwm2014 on Windows and Linux.

## Overview

The project uses **scikit-build-core** + **CMake** + **f2py** to build Fortran extensions for Python. Binary wheels are automatically built for:
- **Windows 64-bit**: Python 3.10+ (using MinGW-w64 toolchain)
- **Linux 64-bit**: Python 3.10+ (using gfortran)

## Prerequisites

### Windows
- Python 3.10+ (64-bit)
- MinGW-w64 toolchain (for gfortran)
- CMake 3.15+
- Build tools: scikit-build-core, ninja, numpy, meson

Install build dependencies:
```bash
pip install scikit-build-core cmake ninja numpy meson
```

Build the package:
```bash
pip install -e .
```

### Linux (Ubuntu/Debian)
- Python 3.10+
- gfortran compiler
- CMake 3.15+
- Build tools: scikit-build-core, ninja, numpy, meson

Install system dependencies:
```bash
sudo apt-get update
sudo apt-get install -y gfortran cmake ninja-build
```

Install Python build dependencies:
```bash
pip install scikit-build-core ninja numpy meson
```

Build the package:
```bash
pip install -e .
```

## Automated CI/CD Build

Pre-built wheels are automatically built using **GitHub Actions** for both Windows and Linux when:
1. Pushing to `main` or `feature/linux-support` branches
2. Creating a release tag (e.g., `v1.2.0`)

The CI workflow:
1. Sets up Python 3.10+ on Ubuntu and Windows
2. Installs system dependencies (gfortran on Linux)
3. Builds wheels using `python -m build --wheel`
4. Uploads artifacts to the workflow run
5. (On release tags) Creates GitHub Release with wheels

### Generated Wheels

For Python 3.10, the following wheels are generated:

**Windows:**
- `pyhwm2014-1.x.x-cp310-cp310-win_amd64.whl`

**Linux:**
- `pyhwm2014-1.x.x-cp310-cp310-linux_x86_64.whl`

## Manual Build Process

### 1. Clone the Repository
```bash
git clone https://github.com/rilma/pyHWM14.git
cd pyHWM14
```

### 2. Create Virtual Environment (optional but recommended)
```bash
# Linux
python3 -m venv .venv
source .venv/bin/activate

# Windows
python -m venv .venv
.venv\Scripts\activate
```

### 3. Install Build Dependencies
```bash
pip install --upgrade pip
pip install scikit-build-core cmake ninja numpy meson
```

### 4. Build and Install the Package
```bash
pip install -e .
```

This will:
1. Run CMake to generate build files
2. Compile the Fortran code using f2py
3. Generate the shared library (`.so` on Linux, `.pyd` on Windows)
4. Install the package in development mode

### 5. Verify the Build
```bash
python -c "from pyhwm2014 import HWM14; print('Success!')"
```

## Build Output

The compiled extension is placed in `pyhwm2014/`:

- **Linux**: `pyhwm2014/hwm14.cp310-linux_x86_64.so`
- **Windows**: `pyhwm2014/hwm14.cp310-win_amd64.pyd`

Along with supporting files:
- `pyhwm2014/libgcc_s_seh-1.dll` (Windows only)
- `pyhwm2014/libgfortran-5.dll` (Windows only)
- `pyhwm2014/libquadmath-0.dll` (Windows only)
- `pyhwm2014/libwinpthread-1.dll` (Windows only)

## Troubleshooting

### CMake not found
```bash
pip install cmake
# or use system package manager
# Ubuntu: sudo apt-get install cmake
```

### gfortran not found
```bash
# Ubuntu/Debian
sudo apt-get install gfortran

# macOS
brew install gcc
```

### NumPy include directory not found
```bash
pip install --upgrade numpy
```

### Build fails with f2py errors
- Ensure `numpy.f2py` is available: `python -m numpy.f2py --help`
- Update NumPy: `pip install --upgrade numpy`
- Check CMakeLists.txt for correct Fortran source paths

### Permission errors on Linux
- Ensure you have write access to the repository directory
- Use `sudo apt-get install` for system dependencies, not `sudo pip install`

## Creating Release Wheels

To create wheels for distribution:

```bash
# Install build tools
pip install build

# Build wheels for current platform
python -m build --wheel

# Wheels will be in dist/
ls dist/
```

To build for multiple Python versions on the same machine:

```bash
for python_version in 3.10 3.11 3.12 3.13; do
    python$python_version -m build --wheel
done
```

## Platform-Specific Notes

### Windows with MinGW-w64

The Windows build uses MinGW-w64 for Fortran compilation. DLL dependencies are bundled:
- `libgcc_s_seh-1.dll` - GCC runtime
- `libgfortran-5.dll` - Fortran runtime
- `libquadmath-0.dll` - Fortran quad math
- `libwinpthread-1.dll` - POSIX threading

These DLLs are automatically discovered on import via `os.add_dll_directory()`.

### Linux

The Linux build uses the system `gfortran`. Ensure the Fortran runtime is installed:
```bash
sudo apt-get install libgfortran5
```

## Further Reading

- [scikit-build-core documentation](https://scikit-build-core.readthedocs.io/)
- [CMake documentation](https://cmake.org/documentation/)
- [NumPy f2py documentation](https://numpy.org/doc/stable/f2py/)
- [Meson build system](https://mesonbuild.com/)
