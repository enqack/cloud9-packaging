#!/bin/sh -e
# lets check if we have the submodules initialized
WORKSPACE=$(pwd)
cd /opt/cloud9 

case `uname -a` in
Linux*x86_64*)  echo "Linux 64 bit"   
    support/node-builds-v4/node-linux64 bin/cloud9.js -w "$WORKSPACE" "$@"
    ;;

Linux*i686*)  echo "Linux 32 bit"   
    support/node-builds-v4/node-linux32 bin/cloud9.js -w "$WORKSPACE" "$@"
    ;;

*) echo "Unknown OS"
   ;;
esac

