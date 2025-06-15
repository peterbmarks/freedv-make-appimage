#!/bin/bash -e
echo "In AppImage AppRun"
export LD_LIBRARY_PATH="${APPIMAGE_LIBRARY_PATH}:${APPDIR}/usr/lib:${LD_LIBRARY_PATH}"
export PATH="$APPDIR/usr/bin"
echo "PATH=$PATH"
export PYTHONPATH="$APPDIR/rade_src:$APPDIR/rade-venv/lib/python3.12/site-packages:$PYTHONPATH"
echo "PYTHONPATH=$PYTHONPATH"
python3 -c "print('Hello, world from python!')"
echo "##### About to import radae_rxe"
python3 -c "import radae_rxe"
"$APPDIR/usr/bin/freedv" $1 $2
deactivate
