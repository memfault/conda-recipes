#!/bin/bash

mkdir $PREFIX/bin

if [ `uname` == Darwin ]; then
    echo "Mounting the disk image"
    DMG=`ls $SRC_DIR/aws-vault*`
    MOUNT_POINT=`hdiutil attach $DMG| tail -n 1 | cut -f 1 -d" "`
    MOUNT_LOCATION=`mount | grep $MOUNT_POINT | cut -d" " -f 3`

    cp $MOUNT_LOCATION/aws-vault $PREFIX/bin

    hdiutil detach $MOUNT_LOCATION
else
    cp $SRC_DIR/aws-vault* $PREFIX/bin/aws-vault
fi

chmod +x $PREFIX/bin/aws-vault
