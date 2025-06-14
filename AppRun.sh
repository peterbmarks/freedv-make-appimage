#!/bin/bash -e
echo "In AppRun"
PATH="$APPDIR/usr/bin:$PATH"
echo "PATH=$PATH"
PYTHONPATH="$APPDIR/rade_src:$APPDIR/rade-venv/lib/python3.12/site-packages:$PYTHONPATH"
echo "PYTHONPATH=$PYTHONPATH"
export LD_LIBRARY_PATH="${APPIMAGE_LIBRARY_PATH}:${APPDIR}/usr/lib:${LD_LIBRARY_PATH}"
"$APPDIR/usr/bin/freedv" $1 $2
deactivate
