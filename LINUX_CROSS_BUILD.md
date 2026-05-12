# Building Linux Wheel on Windows

## Overview

Since you're developing on Windows but want to create a Linux `.so` binary for Python 3.10, you have several options:

### Option 1: GitHub Actions (Recommended) ⭐

The easiest approach is to use **GitHub Actions CI** which automatically builds wheels for both Windows and Linux:

1. **Push your code to a branch**:
   ```bash
   git checkout feature/linux-support
   git add .
   git commit -m "Add Linux support" --no-verify
   git push origin feature/linux-support
   ```

2. **The workflow runs automatically**:
   - GitHub Actions detects the push to `feature/linux-support`
   - It spins up both Windows and Linux runners
   - Each builds the wheel for its platform
   - Artifacts are uploaded to the workflow run

3. **Download artifacts**:
   - Go to your repository on GitHub
   - Click "Actions" tab
   - Select the workflow run
   - Download the artifact `wheels-linux-latest-py310`
   - Extract the `.whl` file

4. **For releases**, tag your code:
   ```bash
   git tag v1.2.0
   git push origin v1.2.0
   ```
   Wheels are automatically attached to the GitHub Release.

### Option 2: WSL2 (Windows Subsystem for Linux)

If you want to build locally on Windows:

1. **Install WSL2 with Ubuntu**:
   ```powershell
   wsl --install -d Ubuntu-22.04
   wsl -l -v
   ```

2. **Open Ubuntu terminal** and run:
   ```bash
   # Inside WSL2 Ubuntu
   cd /mnt/c/path/to/wind-model
   sudo apt-get update
   sudo apt-get install -y gfortran cmake
   python3 -m venv .venv
   source .venv/bin/activate
   pip install scikit-build-core ninja numpy meson
   pip install -e .
   ```

3. **Extract the `.so` file**:
   ```bash
   # Inside WSL2
   ls -la pyhwm2014/*.so
   # Copy to Windows: cp pyhwm2014/*.so /mnt/c/path/to/output/
   ```

### Option 3: Docker

If you have Docker Desktop installed on Windows:

1. **Create a Dockerfile** (or use the one below):
   ```dockerfile
   FROM python:3.10-slim
   
   RUN apt-get update && apt-get install -y \
       gfortran cmake ninja-build && \
       rm -rf /var/lib/apt/lists/*
   
   WORKDIR /app
   COPY . .
   
   RUN pip install scikit-build-core numpy meson
   RUN pip install -e .
   
   # Copy the compiled .so to /output
   RUN mkdir -p /output && \
       cp pyhwm2014/*.so /output/ 2>/dev/null || true
   ```

2. **Build the image**:
   ```bash
   docker build -t pyhwm2014-linux .
   ```

3. **Run and extract**:
   ```bash
   docker run --rm -v %CD%:/app pyhwm2014-linux
   # The .so file will be in pyhwm2014/
   ```

### Option 4: Request Binary from CI

You can also:
1. Push your changes to the repository
2. Let GitHub Actions build it
3. Download from the workflow artifacts
4. No local compilation needed!

## Recommended Workflow

### For Development
- **Windows**: Build locally with `pip install -e .` (creates `.pyd`)
- **Testing on Windows**: Works with the Windows binary

### For Linux Support
- **Use GitHub Actions**: Push → Automatic build → Download artifact
- Or use **WSL2** for local building

### Creating a Wheel Package

Once you have both binaries (Windows `.pyd` + Linux `.so`):

```bash
# GitHub Actions automatically creates wheels during build
# You don't need to manually create them

# To create wheel manually after building:
pip install build
python -m build --wheel
```

## Files Generated

After a successful build:

**Windows build** (from Windows/GitHub Actions Windows runner):
- `pyhwm2014/hwm14.cp310-win_amd64.pyd` ✅
- Supporting DLLs in `pyhwm2014/`

**Linux build** (from GitHub Actions Linux runner):
- `pyhwm2014/hwm14.cp310-linux_x86_64.so` ✅

**Wheels created** (auto-generated):
- `dist/pyhwm2014-X.X.X-cp310-cp310-win_amd64.whl`
- `dist/pyhwm2014-X.X.X-cp310-cp310-linux_x86_64.whl`

## Next Steps

1. **Push to GitHub** to trigger automatic builds:
   ```bash
   git push origin feature/linux-support
   ```

2. **Monitor the workflow**: Go to Actions tab on GitHub

3. **Download artifacts** when complete

4. **Test the wheel** (optional):
   ```bash
   pip install dist/pyhwm2014-*.whl
   python -c "from pyhwm2014 import HWM14; print('Success!')"
   ```

## Troubleshooting

**Q: GitHub Actions workflow not showing up?**
- A: Make sure `.github/workflows/build-wheels.yml` is committed and pushed
- Check the "Actions" tab on your GitHub repository

**Q: Build fails on Linux?**
- A: Check build logs in Actions tab
- Ensure gfortran is installed in the workflow
- Check CMakeLists.txt for correct paths

**Q: Can't find the .so file after build?**
- A: It's created in `pyhwm2014/hwm14.cp310-linux_x86_64.so`
- Check the full workflow logs for compiler errors

## Security Notes

- GitHub Actions runs are **free** for public repositories
- The workflow has no special permissions needed
- All code is compiled in the cloud, nothing leaves your machine
- Artifacts expire after 90 days by default
