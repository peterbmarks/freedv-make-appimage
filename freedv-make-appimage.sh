#!/bin/bash -e
# This is tested on Ubuntu 22.04
# Requires the freedv-rade-build script to be run first
# https://github.com/barjac/freedv-rade-build
# pre-requisites:
# sudo apt intstall icnsutils git 

# to run sudo apt install libfuse2t64
# to look inside ./FreeDV-x86_64.AppImage --appimage-mount /tmp/freedv
# https://gist.github.com/peterbmarks/e329cbaad9a52808f29458a91df67f55

APPNAME="FreeDV"
DIR="$APPNAME.AppDir"
BUILDDIR="freedv-rade/freedv-gui"
if [ -d "$DIR" ]; then
    echo "Deleting $DIR..."
    rm -rf "$DIR"
else
    echo "$DIR does not exist."
fi
echo "Creating $DIR..."
mkdir "$DIR"

echo "Creating desktop file..."
echo -e "[Desktop Entry]\nName=$APPNAME\nExec=freedv\nIcon=$APPNAME\nType=Application\nCategories=Utility;" > "$DIR/FreeDV.desktop"

echo "Create icon..."
cp "$BUILDDIR/src/freedv.icns" "$DIR/."
icns2png -x -s 256 -o . "$DIR/freedv.icns"
mv "freedv_256x256x32.png" "$DIR/FreeDV.png" 
rm "$DIR/freedv.icns"

echo "Copy RADE source..."
cp -r "$BUILDDIR/build_linux/rade_src" "$DIR/."

echo "Copy python venv..."
cp -r "$BUILDDIR/rade-venv" "$DIR/."

# echo "Copy embedded python..."
# cp -r "$BUILDDIR/src/rade_src" "$DIR/."

echo "Bundle dependencies..."
if test -f linuxdeploy-x86_64.AppImage; then
  echo "linuxdeploy exists"
else
    wget https://github.com/linuxdeploy/linuxdeploy/releases/latest/download/linuxdeploy-x86_64.AppImage
    chmod +x linuxdeploy-x86_64.AppImage
fi

./linuxdeploy-x86_64.AppImage --appdir "$DIR" \
--desktop-file "$DIR/$APPNAME".desktop \
--icon-file "$DIR/$APPNAME".png \
--executable $BUILDDIR/build_linux/src/freedv

echo "Copy libraries..."
mkdir "$DIR/bin"
#cp "$BUILDDIR/build_linux/rade_build/src/librade.so.0.1" "$DIR/bin/."
echo "Creating app image..."
if test -f appimagetool-x86_64.AppImage; then
  echo "appimagetool exists"
else
    wget https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage
    chmod +x appimagetool-x86_64.AppImage
fi
./appimagetool-x86_64.AppImage "$DIR"

echo "Done"
