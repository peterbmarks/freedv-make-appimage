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

echo "Fix venv python links..."
cd "$DESTDIR/rade-venv/bin"
echo "Now in $(pwd)"
ln -s -f ../../../usr/bin/python3 python
ln -s -f ../../../usr/bin/python3 python3
ln -s -f ../../../usr/bin/python3 python3.14
cd - # back to the previous directory
echo "Now in $(pwd)"

# Copy our custom AppRun
cp -f AppRun Play.AppDir/.

# Create the output
./linuxdeploy-x86_64.AppImage \
--appdir FreeDV.AppDir \
--output appimage

# TODO copy the models and symlink
ln -s -f "$DESTDIR/freedv-gui/build_linux/rade_src/model19_check3" "$DESTDIR/freedv-gui/build_linux/model19_check3"

echo "Done"
