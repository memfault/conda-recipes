# if VOLTA_HOME is set, save it to VOLTA_HOME_BACKUP
if [ -n "$VOLTA_HOME" ]; then
  export VOLTA_HOME_BACKUP="$VOLTA_HOME"
fi

# set the volta directory to reside inside the conda environment
export VOLTA_HOME="$CONDA_PREFIX"/.volta
