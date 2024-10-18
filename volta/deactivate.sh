#!/bin/bash

# if VOLTA_HOME_PREFERRED is set, don't unset VOLTA_HOME; the user activated the
# conda environment with VOLTA_HOME already set, and we don't want to mess with
# it
if [ -n "$VOLTA_HOME_PREFERRED" ]; then
  unset VOLTA_HOME_PREFERRED
else
  # remove the directory from PATH
  directory_to_remove=$VOLTA_HOME/bin
  new_path=""
  old_ifs=$IFS
  IFS=":"
  for dir in $PATH; do
    if [ "$dir" != "$directory_to_remove" ]; then
      new_path="$new_path:$dir"
    fi
  done
  IFS=$old_ifs

  # Remove the leading colon if necessary
  PATH=${new_path#:}

  unset VOLTA_HOME
fi
