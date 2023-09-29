# if VOLTA_HOME is set, don't override it- save it so the deactivate script
# knows to not unset it
if [ -n "${VOLTA_HOME-}" ]; then
  export VOLTA_HOME_PREFERRED="$VOLTA_HOME"
else
  # set the volta directory to reside inside the conda environment
  export VOLTA_HOME="$CONDA_PREFIX"/.volta
  export PATH="$VOLTA_HOME/bin:$PATH"
fi
