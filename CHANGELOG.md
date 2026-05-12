# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Linux 64-bit support (Python 3.10+) with automatic GitHub Actions builds
- Multi-platform wheel generation (Windows + Linux) in CI pipeline
- `BUILDING.md` documentation for building from source
- `LINUX_CROSS_BUILD.md` guide for building Linux binaries on Windows
- Support for Python 3.10, 3.11, 3.12 in addition to 3.13
- Enhanced error messages when native extension is not found
- GitHub Actions workflow for automatic multi-platform wheel builds
- Simplified Makefile for Python 3.10+ development (Linux)
- Enhanced CI/CD pipeline with linting, type checking, and security audits
- Comprehensive CONTRIBUTING.md guide for collaboration
- MAINTENANCE.md documenting release and maintenance processes
- ROADMAP.md outlining future development directions
- Pre-commit hook configuration for automated code quality checks
- Coverage reporting in CI pipeline via Codecov
- Security vulnerability scanning with pip-audit

### Fixed
- (Pending)

### Changed
- Updated GitHub Actions versions (v3 → v4, v4 → v5)
- Improved CI workflow organization (separate lint, test, security jobs)
- Minimum Python version from 3.13 to 3.10 for better compatibility
- Updated pyproject.toml to support Python 3.10+ on multiple platforms
- Makefile now uses standard venv instead of uv for broader compatibility

### Deprecated
- (None at this time)

### Removed
- (None at this time)

### Security
- Added automated security audit during CI pipeline

## [1.1.0] - 2026-02-15

### Added
- Full type hint coverage with mypy strict mode
- Comprehensive test suite covering all major functionality
- PyPI publishing with automated CI/CD pipeline
- Support for Python 3.13
- Modern build system (scikit-build-core)
- API documentation with docstrings

### Fixed
- Initial release of pyHWM14 package

## [Previous]

See GitHub releases for historical versions: https://github.com/rilma/pyHWM14/releases
