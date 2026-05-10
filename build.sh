#!/bin/sh
set -e

BUILD_DIR=_cmake
OUTPUT_DIR=_build

mkdir -p "$BUILD_DIR"
mkdir -p "$OUTPUT_DIR"

cd "$BUILD_DIR"

if [ "$(uname)" = "Darwin" ]; then
    cmake .. -DCMAKE_BUILD_TYPE=Release
else
    cmake .. -DCMAKE_BUILD_TYPE=Release
fi

make -j$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)

cd ..
echo ""
if [ "$(uname)" = "Darwin" ]; then
    echo "Build succeeded. App bundle: $OUTPUT_DIR/gred.app"
    echo "Launcher symlink: $OUTPUT_DIR/gred"
else
    echo "Build succeeded. Executable: $OUTPUT_DIR/gred"
fi
