# if VOLTA_HOME_BACKUP is set, restore it to VOLTA_HOME
unset VOLTA_HOME
if [ -n "$VOLTA_HOME_BACKUP" ]; then
  export VOLTA_HOME="$VOLTA_HOME_BACKUP"
  unset VOLTA_HOME_BACKUP
fi
