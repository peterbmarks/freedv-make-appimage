#!/bin/bash -e
echo "In AppRun"
source "$APPDIR/rade-venv/bin/activate"
echo "PYTHONPATH=$PYTHONPATH"
export LD_LIBRARY_PATH="${APPIMAGE_LIBRARY_PATH}:${APPDIR}/usr/lib:${LD_LIBRARY_PATH}"
"$APPDIR/usr/bin/freedv" $1 $2
deactivate
