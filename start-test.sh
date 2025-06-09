#!/bin/bash
# Test the build using the AppDir tree
APPDIR="$HOME/freedv-make-appimage/FreeDV.AppDir"

# ./FreeDV-x86_64.AppImage --appimage-mount 
#APPDIR=/tmp/.mount_FreeDVc5qK7Y
echo "### appdir=$APPDIR"
source "$APPDIR/freedv-gui/rade-venv/bin/activate"
PYTHONPATH="$APPDIR/freedv-gui/build_linux/rade_src:$PYTHONPATH" "$APPDIR/freedv-gui/build_linux/src/freedv" $1 $2
deactivate
