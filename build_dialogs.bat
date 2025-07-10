@echo off

echo # Building dialogs module ...
g++ -o gred/dialogs.dll dialogs/dialogs.cpp dialogs/tinyfiledialogs.c -lcomdlg32 -lole32 -O2 -shared -static -s -m32

echo # Done.
