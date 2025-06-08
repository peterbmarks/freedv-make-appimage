# freedv-make-appimage
Script to create an app image from the FreeDV GUI

# Not working yet!
Well, the app launches and you can use legacy modes but RADE isn't running yet.

If I start RADE the app exits after printing:
15:59:37 [18] WARN /home/marksp/freedv-rade/freedv-gui/src/gui/dialogs/freedv_reporter.cpp:1997: Received duplicate user during connection process
15:59:37 [19] INFO /home/marksp/freedv-rade/freedv-gui/src/util/SocketIoClient.cpp:230: socket.io connect
model file: 
import_array returned: 0
ModuleNotFoundError: No module named 'radae_txe'
Error: importing radae_txe


# Useful notes

To look inside ./FreeDV-x86_64.AppImage --appimage-mount 
https://docs.appimage.org/user-guide/run-appimages.html
