#!/bin/bash -e

APPNAME="FreeDV"
DESTDIR="$APPNAME.AppDir"
BUILDDIR="../freedv-rade/freedv-gui"

# Change to the directory where this script is located
cd "$(dirname "$(realpath "$0")")"

if [ -d "$DESTDIR" ]; then
    echo "Deleting $DESTDIR..."
    rm -rf "$DESTDIR"
else
    echo "$DESTDIR does not exist."
fi

echo "Bundle dependencies..."
if test -f linuxdeploy-x86_64.AppImage; then
  echo "linuxdeploy exists"
else
    wget https://github.com/linuxdeploy/linuxdeploy/releases/latest/download/linuxdeploy-x86_64.AppImage
    chmod +x linuxdeploy-x86_64.AppImage
fi

./linuxdeploy-x86_64.AppImage \
--executable /usr/bin/python3 \
--executable ~/freedv-rade/freedv-gui/build_linux/src/freedv \
--appdir "$DESTDIR" \
--icon-file FreeDVIcon.png \
--desktop-file FreeDV.desktop

# create the virtual environment (copied from Brian's build script)
cd FreeDV.AppDir
python3 -m venv rade-venv --system-site-packages # || { echo "ERROR: create venv failed"; exit 1; }
# Activate it
source rade-venv/bin/activate # || { echo "ERROR: activate venv failed"; exit 1; }

# Clear cache in venv
pip cache purge
pip install --upgrade pip || echo "WARNING: pip upgrade failed"
pip3 install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
pip3 install matplotlib
pip3 install NumPy
cd -

echo "Fix venv python links..."
echo "Now in $(pwd)"
cd "$DESTDIR/rade-venv/bin"
echo "Now in $(pwd)"
ln -s -f ../../usr/bin/python3 python
ln -s -f ../../usr/bin/python3 python3
ln -s -f ../../usr/bin/python3 python3.12
cd - # back to the previous directory
echo "### Now in $(pwd)"

# TODO copy the models and symlink
# ls freedv-rade/freedv-gui/build_linux/rade_src/model
# model05/        model17/        model18/        model19/        model19_check3/ model_bbfm_01/  
cp -r "$BUILDDIR/build_linux/rade_src/model19_check3" "$DESTDIR/."

# Copy our custom AppRun
echo "Copy custom AppRun..."
rm "$DESTDIR/AppRun"
cp -f AppRun "$DESTDIR/AppRun"

# Create the output
./linuxdeploy-x86_64.AppImage \
--appdir "$DESTDIR" \
--output appimage

echo "Done"
