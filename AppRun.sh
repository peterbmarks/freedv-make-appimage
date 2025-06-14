#!/bin/bash -e
echo "In AppRun"
export PATH="$APPDIR/usr/bin"
echo "PATH=$PATH"

source "$APPDIR/rade-venv/bin/activate"
export PYTHONPATH="$APPDIR/rade-venv/lib/python3.12/site-packages/:$PYTHONPATH"
echo "PYTHONPATH=$PYTHONPATH"

export LD_LIBRARY_PATH="${APPIMAGE_LIBRARY_PATH}:${APPDIR}/usr/lib:${LD_LIBRARY_PATH}"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

"$APPDIR/usr/bin/freedv" $1 $2
deactivate
