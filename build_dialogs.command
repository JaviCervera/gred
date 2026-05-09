#!/usr/bin/env bash
set -euo pipefail

# macOS universal build script for gred/dialogs.dylib
# Builds from dialogs/dialogs.cpp and dialogs/tinyfiledialogs.c
# Compiles per-arch object files (C++ and C separately) to avoid C/C++ mode warnings,
# enables MS __declspec support and combines per-arch dylibs with lipo.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/dialogs"
OUT_DIR="$SCRIPT_DIR/gred"
OUTPUT="$OUT_DIR/dialogs.dylib"
CXX="${CXX:-clang++}"
CC="${CC:-clang}"
CXXFLAGS="${CXXFLAGS:--O2 -mmacosx-version-min=10.9 -fPIC -fdeclspec -fms-extensions}"
CFLAGS="${CFLAGS:--O2 -mmacosx-version-min=10.9 -fPIC}"
LDFLAGS="${LDFLAGS:-}"

mkdir -p "$OUT_DIR"

echo "Building universal (arm64 + x86_64) -> $OUTPUT"

TMP_DYLIBS=()
for ARCH in arm64 x86_64; do
  BUILD_DIR="$OUT_DIR/build-$ARCH"
  mkdir -p "$BUILD_DIR"
  OBJ_CPP="$BUILD_DIR/dialogs.o"
  OBJ_C="$BUILD_DIR/tinyfiledialogs.o"
  OUT_DYLIB="$OUT_DIR/dialogs-$ARCH.dylib"

  echo "Compiling for arch: $ARCH"
  echo "  C++: $CXX -c -arch $ARCH $SRC_DIR/dialogs.cpp -I$SRC_DIR $CXXFLAGS -o $OBJ_CPP"
  $CXX -c -arch "$ARCH" "$SRC_DIR/dialogs.cpp" -I"$SRC_DIR" $CXXFLAGS -o "$OBJ_CPP"

  echo "  C: $CC -c -arch $ARCH $SRC_DIR/tinyfiledialogs.c -I$SRC_DIR $CFLAGS -o $OBJ_C"
  $CC -c -arch "$ARCH" "$SRC_DIR/tinyfiledialogs.c" -I"$SRC_DIR" $CFLAGS -o "$OBJ_C"

  echo "  Linking: $CXX -dynamiclib -arch $ARCH -o $OUT_DYLIB $OBJ_CPP $OBJ_C $LDFLAGS"
  $CXX -dynamiclib -arch "$ARCH" -o "$OUT_DYLIB" "$OBJ_CPP" "$OBJ_C" $LDFLAGS

  TMP_DYLIBS+=("$OUT_DYLIB")
done

if command -v lipo >/dev/null 2>&1; then
  echo "Creating universal dylib via lipo -> $OUTPUT"
  lipo -create -output "$OUTPUT" "${TMP_DYLIBS[@]}"
  echo "Universal created: $OUTPUT"
  # cleanup
  rm -rf "$OUT_DIR/build-"* "${TMP_DYLIBS[@]}"
  exit 0
else
  echo "lipo not found; per-arch dylibs located: ${TMP_DYLIBS[*]}" >&2
  exit 1
fi
