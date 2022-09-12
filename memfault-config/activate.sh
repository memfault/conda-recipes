export MEMFAULT_DEPS_ROOT="$CONDA_PREFIX"

# This works around a python poetry issue:
# https://github.com/python-poetry/poetry/issues/1917
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
