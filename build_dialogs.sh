#!/bin/sh
cd `dirname $0`
echo "Building dialogs module..."
g++ -o gred/dialogs.so dialogs/dialogs.cpp dialogs/tinyfiledialogs.c -O2 -shared -s -fPIC
