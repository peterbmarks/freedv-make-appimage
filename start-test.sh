#!/bin/bash
cd "$HOME/freedv-make-appimage/FreeDV.AppDir/freedv-gui"
. ./rade-venv/bin/activate
cd build_linux
PYTHONPATH="$(pwd)/rade_src:$PYTHONPATH" src/freedv $1 $2
deactivate
