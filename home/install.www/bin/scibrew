#!/bin/bash
# scibrew -- a shell script to help bootstrap homebrew, scibrew, and lmod.
# on OSX, the script initially installs itself in $HOME/local/bin and then
# over the course of the installation, it installs itself into /usr/local

programname=$0

function usage {
echo "usage: $programname [-hxtm]"
echo "This script helps bootstrap homebrew, scibrew, and lmod."
echo "OPTIONS:"
echo "-h      Show this message"
echo "-x      xcode command line tools install"
echo "-t      add taps for homebrew-versions and all the scibrew taps"
echo "-m      install lmod (requires taps)"
exit 1
			}
while getopts ":hxtm" OPTION; do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		x) 
			 echo "xcode-select --install" | bash
			 ;;
		t)
			 brew tap homebrew/versions
			 brew tap hovr2pi/scibrew
			 brew tap hovr2pi/serialgnu
			 ;;
		 m) 
			 brew install luarocks
			 luarocks install luaposix
			 luarocks install LuaFileSystem
			 brew install lmod
			 ;;
		 ?) 
			 usage
			 ;;
	esac
done
