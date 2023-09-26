# if VOLTA_HOME_PREFERRED is set, don't unset VOLTA_HOME; the user activated the
# conda environment with VOLTA_HOME already set, and we don't want to mess with
# it
if [ -n "$VOLTA_HOME_PREFERRED" ]; then
  unset VOLTA_HOME_PREFERRED
else
  # otherwise, clean up after ourselves
  directory_to_remove=$VOLTA_HOME/bin
  # from https://unix.stackexchange.com/a/108933
  PATH=:$PATH:
  PATH=${PATH//:$directory_to_remove:/:}
  PATH=${PATH#:}
  PATH=${PATH%:}
  unset VOLTA_HOME
fi
