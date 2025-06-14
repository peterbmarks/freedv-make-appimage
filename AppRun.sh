#!/bin/bash -e
echo "In AppRun"
export PATH="$APPDIR/usr/bin:$APPDIR/rade-venv/bin"
echo "PATH=$PATH"

source "$APPDIR/rade-venv/bin/activate"
export PYTHONPATH="$APPDIR/rade-venv/lib/python3.12/site-packages/:$APPDIR/rade_src:$PYTHONPATH"
echo "PYTHONPATH=$PYTHONPATH"

python -c "print('Hello, world from python!')"
#echo "##### About to import radae_rxe"
#python3 -v -c "import radae_rxe"

export LD_LIBRARY_PATH="${APPIMAGE_LIBRARY_PATH}:${APPDIR}/usr/lib:${LD_LIBRARY_PATH}"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

"$APPDIR/usr/bin/freedv" $1 $2
deactivate
