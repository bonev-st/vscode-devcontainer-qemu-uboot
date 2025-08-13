#!/usr/bin/env bash
set -euo pipefail
ROOT="/workspaces/project"
UBOOT="$ROOT/Day1/u-boot"
BUILD="$UBOOT/build"

if [ ! -d "$UBOOT" ]; then
  echo "U-Boot not found. Run scripts/setup.sh first."
  exit 1
fi

pushd "$UBOOT" >/dev/null
rm -rf "$BUILD"
mkdir -p "$BUILD"
make mrproper
make O="$BUILD" sandbox_defconfig
make O="$BUILD" -j"$(nproc)"
echo
echo "QEMU ARM64 U-Boot build complete."
echo "Binary: $BUILD/u-boot.bin"
popd >/dev/null
