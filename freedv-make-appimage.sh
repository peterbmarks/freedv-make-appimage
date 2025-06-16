#!/bin/bash -e

APPNAME="FreeDV"
APPDIR="$APPNAME.AppDir"
BUILDDIR="../freedv-rade/freedv-gui"

# Change to the directory where this script is located
cd "$(dirname "$(realpath "$0")")"

if [ -d "$APPDIR" ]; then
    echo "Deleting $APPDIR..."
    rm -rf "$APPDIR"
else
    echo "$APPDIR does not exist."
fi


echo "Bundle dependencies..."
if test -f linuxdeploy-x86_64.AppImage; then
  echo "linuxdeploy exists"
else
    wget https://github.com/linuxdeploy/linuxdeploy/releases/latest/download/linuxdeploy-x86_64.AppImage
    chmod +x linuxdeploy-x86_64.AppImage
fi

./linuxdeploy-x86_64.AppImage \
--executable ~/freedv-rade/freedv-gui/build_linux/src/freedv \
--executable /usr/bin/dirname \
--executable /usr/bin/find \
--executable /usr/bin/head \
--executable /usr/bin/grep \
--appdir "$APPDIR" \
--icon-file FreeDVIcon.png \
--custom-apprun=AppRun.sh \
--desktop-file FreeDV.desktop

echo "Get standalone python..."
export PYTHONFILENAME="release-3.12-x86_64.tar.gz"
export PYTHONAPPIMAGEURL="https://github.com/scc-tw/standalone-python/releases/download/release-2024-04-29/release-3.12-x86_64.tar.gz"
if test -f "$PYTHONFILENAME"; then
  echo "python appimage exists"
else
  wget "$PYTHONAPPIMAGEURL"
  chmod +x "$PYTHONFILENAME"
fi
tar xzvf "$PYTHONFILENAME" # unpacks to an opt tree
mv opt "$APPDIR/."

# create the virtual environment (copied from Brian's build script)
cd "$APPDIR"
opt/python/bin/python3 -m venv rade-venv # || { echo "ERROR: create venv failed"; exit 1; }
# Activate it
source rade-venv/bin/activate # || { echo "ERROR: activate venv failed"; exit 1; }

# Clear cache in venv
pip3 cache purge
pip3 install --upgrade pip || echo "WARNING: pip upgrade failed"
pip3 install "numpy<2"
pip3 install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
pip3 install matplotlib
cd -

echo "Fix venv python links..."
echo "Now in $(pwd)"
cd "$APPDIR/rade-venv/bin"
echo "Now in $(pwd)"
rm python python3 python3.12 python3.12-real
ln -s --relative ../../opt/python/bin/python3 python
ln -s --relative ../../opt/python/bin/python3 python3
ln -s --relative ../../opt/python/bin/python3 python3.12
ln -s --relative ../../opt/python/bin/python3 python3.12-real
cd - # back to the previous directory
echo "### Now in $(pwd)"

# Copy the models and symlink
echo "Copying rade_src..."
# ls freedv-rade/freedv-gui/build_linux/rade_src/model
# model05/        model17/        model18/        model19/        model19_check3/ model_bbfm_01/  
cp -r "$BUILDDIR/build_linux/rade_src" "$APPDIR/."
cd "$APPDIR/usr/bin"
ln -s "../../rade_src/model19_check3" "model19_check3"
cd -

# Create the output
./linuxdeploy-x86_64.AppImage \
--appdir "$APPDIR" \
--icon-file FreeDVIcon.png \
--desktop-file FreeDV.desktop \
--output appimage

echo "Done"
