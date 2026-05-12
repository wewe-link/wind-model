
# Python 3.10+ with scikit-build-core + CMake + f2py
# Supports Python 3.10, 3.11, 3.12, 3.13
# For Windows: use 'pip install -e .' directly
# For Linux: use 'make install' for full development setup

PYTHON ?= python3
VENV_DIR = .venv
CLEAN_VENV ?= 0

.PHONY: install-gfortran install test clean \
	pre-commit-install pre-commit-run lint type-check check fix help

help:
	@echo "Available targets:"
	@echo "  make install         - Install package with build dependencies (Linux)"
	@echo "  make test            - Run test suite"
	@echo "  make lint            - Run code linting (ruff)"
	@echo "  make type-check      - Run type checking (mypy)"
	@echo "  make check           - Run all checks (lint + type-check)"
	@echo "  make fix             - Auto-fix code formatting"
	@echo "  make clean           - Remove build artifacts"

install-gfortran:
	@if command -v gfortran >/dev/null 2>&1; then \
		echo "gfortran already installed"; \
	else \
		echo "Installing gfortran..."; \
		sudo apt-get update && sudo apt-get -y install gfortran; \
	fi

install: install-gfortran
	$(PYTHON) -m venv $(VENV_DIR) || python3 -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install --upgrade pip
	$(VENV_DIR)/bin/pip install scikit-build-core cmake ninja numpy meson pytest pytest-cov ruff mypy black
	rm -rf build dist pyhwm2014.egg-info
	$(VENV_DIR)/bin/pip install -e .

test: 
	@if [ -d "$(VENV_DIR)" ]; then \
		$(VENV_DIR)/bin/python -m pytest tests/ -v --tb=short; \
	else \
		$(PYTHON) -m pytest tests/ -v --tb=short; \
	fi

clean:
	rm -rf build dist pyhwm2014.egg-info
	find . -type d -name "__pycache__" -prune -exec rm -rf {} +
	find . -type f -name "*.py[co]" -delete
	find . -type f -name "*.so" -delete
	rm -f .coverage
	@if [ "$(CLEAN_VENV)" = "1" ]; then rm -rf $(VENV_DIR); fi

pre-commit-install: install
	$(VENV_DIR)/bin/pre-commit install

pre-commit-run:
	$(VENV_DIR)/bin/pre-commit run --all-files

lint:
	@echo "Running ruff linter..."; \
	@if [ -d "$(VENV_DIR)" ]; then \
		$(VENV_DIR)/bin/ruff check pyhwm2014 tests; \
		$(VENV_DIR)/bin/ruff format --check pyhwm2014 tests; \
	else \
		ruff check pyhwm2014 tests; \
		ruff format --check pyhwm2014 tests; \
	fi

type-check:
	@echo "Running mypy type checker..."; \
	@if [ -d "$(VENV_DIR)" ]; then \
		$(VENV_DIR)/bin/mypy pyhwm2014; \
	else \
		mypy pyhwm2014; \
	fi

check: lint type-check
	@echo "✅ All checks passed!"

fix:
	@echo "Running auto-fixes..."
	@if [ -d "$(VENV_DIR)" ]; then \
		$(VENV_DIR)/bin/ruff format pyhwm2014 tests; \
		$(VENV_DIR)/bin/ruff check --fix pyhwm2014 tests || true; \
		$(VENV_DIR)/bin/mypy pyhwm2014 || true; \
	else \
		ruff format pyhwm2014 tests; \
		ruff check --fix pyhwm2014 tests || true; \
		mypy pyhwm2014 || true; \
	fi
	@echo "✅ Auto-fixes applied!"
