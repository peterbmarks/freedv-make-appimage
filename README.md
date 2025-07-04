# freedv-make-appimage
Script to create an app image from the FreeDV GUI

Requires the freedv-rade-build script to be run first
https://github.com/barjac/freedv-rade-build
## pre-requisites:
# sudo apt install icnsutils git libfuse-dev libfuse2t64

# Works on
* Ubuntu 24.04.2 LTS

# Fails on
* Ubuntu 25.04 - Error import ctypes


# Useful notes

To look inside ./FreeDV-x86_64.AppImage --appimage-mount 
https://docs.appimage.org/user-guide/run-appimages.html

Usage: freedv [-h] [--verbose] [-f <str>] [-ut <str>] [-utmode <str>] [-rxfile <str>] [-txfile <str>] [-rxfeaturefile <str>] [-txfeaturefile <str>] [-txtime <num>] [-txattempts <num>]
  -h, --help            	show this help message
  --verbose             	generate verbose log messages
  -f, --config=<str>    	Use different configuration file instead of the default.
  -ut, --unit_test=<str>	Execute FreeDV in unit test mode.
  -utmode:<str>         	Switch FreeDV to the given mode before UT execution.
  -rxfile:<str>         	In UT mode, pipes given WAV file through receive pipeline.
  -txfile:<str>         	In UT mode, pipes given WAV file through transmit pipeline.
  -rxfeaturefile:<str>  	Capture RX features from RADE decoder into the provided file.
  -txfeaturefile:<str>  	Capture TX features from FARGAN encoder into the provided file.
  -txtime, --60=<num>   	In UT mode, the amount of time to transmit (default 60 seconds)
  -txattempts, --1=<num>	In UT mode, the number of times to transmit (default 1)

Debug missing libraries:

LD_DEBUG=libs ./FreeDV-x86_64.AppImage


Interesting example: https://github.com/gmagno/spyci/blob/83935c3c07f1566fbdbaef31f7fbb1f6c92feaf5/appimage/build-appimage.sh#L7