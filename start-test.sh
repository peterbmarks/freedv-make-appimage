#!/bin/bash
# Test the build using the AppDir tree
APPDIR="$HOME/freedv-make-appimage/FreeDV.AppDir"
echo "### appdir=$APPDIR"
source "$APPDIR/freedv-gui/rade-venv/bin/activate"
PYTHONPATH="$APPDIR/freedv-gui/build_linux/rade_src:$PYTHONPATH" "$APPDIR/freedv-gui/build_linux/src/freedv" $1 $2
deactivate
