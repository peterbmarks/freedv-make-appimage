#!/bin/bash -e
# This is tested on Ubuntu 22.04
# Requires the freedv-rade-build script to be run first
# https://github.com/barjac/freedv-rade-build
# pre-requisites:
# sudo apt intstall icnsutils git 

# to run sudo apt install libfuse2t64
# to look inside ./FreeDV-x86_64.AppImage --appimage-mount /tmp/freedv
# https://gist.github.com/peterbmarks/e329cbaad9a52808f29458a91df67f55
# https://docs.appimage.org/packaging-guide/environment-variables.html#id2


APPNAME="FreeDV"
DIR="$APPNAME.AppDir"
BUILDDIR="../freedv-rade/freedv-gui"

# Change to the directory where this script is located
cd "$(dirname "$(realpath "$0")")"

if [ -d "$DIR" ]; then
    echo "Deleting $DIR..."
    rm -rf "$DIR"
else
    echo "$DIR does not exist."
fi
echo "Creating $DIR..."
mkdir "$DIR"

echo "Copying desktop file..."
cp FreeDV.desktop "$DIR/FreeDV.desktop"

echo "Creating icon..."
cp "$BUILDDIR/src/freedv.icns" "$DIR/."
icns2png -x -s 256 -o . "$DIR/freedv.icns"
mv "freedv_256x256x32.png" "$DIR/FreeDV.png" 
rm "$DIR/freedv.icns"

echo "Copy code..."
mkdir -p "$DIR/usr/bin"
cp -r "$BUILDDIR" "$DIR/."

echo "Bundle dependencies..."
if test -f linuxdeploy-x86_64.AppImage; then
  echo "linuxdeploy exists"
else
    wget https://github.com/linuxdeploy/linuxdeploy/releases/latest/download/linuxdeploy-x86_64.AppImage
    chmod +x linuxdeploy-x86_64.AppImage
fi

echo "Get python appimage..."
if test -f python3.14.0b1-cp314-cp314-manylinux2014_x86_64.AppImage; then
  echo "python appimage exists"
else
  wget https://github.com/niess/python-appimage/releases/download/python3.14/python3.14.0b1-cp314-cp314-manylinux2014_x86_64.AppImage
  chmod +x python3.14.0b1-cp314-cp314-manylinux2014_x86_64.AppImage
fi

cp python3.14.0b1-cp314-cp314-manylinux2014_x86_64.AppImage "$DIR/usr/bin/python3"

# echo "Create python virtual environment..."
# export PATH="$DIR/usr/bin":$PATH
# cd "$DIR"
# python3 -m venv rade-venv --system-site-packages || { echo "ERROR: create venv failed"; exit 1; }
# cd rade-venv
# . ./bin/activate || { echo "ERROR: activate venv failed"; exit 1; }
# # Clear cache in venv
# python3 -m pip cache purge
# python3 -m pip install --upgrade pip || echo "WARNING: pip upgrade failed"

# # Install some python dependencies using pip
# python3 -m pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu || { echo "torch pip install failed"; exit 1; }

# python3 -m pip install matplotlib || { echo "ERROR: matplotlib pip install failed"; exit 1; }

# python3 -m pip3 install NumPy || { echo "ERROR: numpy pip install failed"; exit 1; }

echo "Fix venv python links..."
#rm "$DIR/freedv-gui/rade-venv/bin/python*"
cd "$DIR/freedv-gui/rade-venv/bin"
echo "Now in $(pwd)"
ln -s -f ../../../usr/bin/python3 python
ln -s -f ../../../usr/bin/python3 python3
ln -s -f ../../../usr/bin/python3 python3.12 #not really
ln -s -f ../../../usr/bin/python3 python3.14
cd - # back to the previous directory
echo "Now in $(pwd)"

./linuxdeploy-x86_64.AppImage --appdir "$DIR" \
--desktop-file "$DIR/$APPNAME".desktop \
--icon-file "$DIR/$APPNAME".png \
--executable $BUILDDIR/build_linux/src/freedv

# APPDIR is the path of mountpoint of the SquashFS image contained in the AppImage
echo "Installing the AppRun script in $DIR..."
rm "$DIR/AppRun"
cp -f AppRun "$DIR/."
chmod +x "$DIR/AppRun"

echo "Creating app image..."
if test -f appimagetool-x86_64.AppImage; then
  echo "appimagetool exists"
else
    wget https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage
    chmod +x appimagetool-x86_64.AppImage
fi
./appimagetool-x86_64.AppImage "$DIR"

echo "Symlink model19_check3..."
ln -s -f "$DIR/freedv-gui/build_linux/rade_src/model19_check3" "$DIR/freedv-gui/build_linux/model19_check3"



echo "Done"
