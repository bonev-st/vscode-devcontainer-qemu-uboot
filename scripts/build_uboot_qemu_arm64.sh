#!/usr/bin/env bash
set -euo pipefail
ROOT="/workspaces/project"
UBOOT="$ROOT/Day1/u-boot"
BUILD="$UBOOT/build"

source "$ROOT"/scripts/env.sh

if [ -z "${CROSS_COMPILE:-}" ]; then
  echo "CROSS_COMPILE not set. Did you 'source scripts/env.sh'?"
  exit 1
fi

pushd "$UBOOT" >/dev/null
rm -rf "$BUILD"
mkdir -p "$BUILD"

make mrproper
make O="$BUILD" qemu_arm64_defconfig
make O="$BUILD" -j"$(nproc)"
echo
echo "QEMU ARM64 U-Boot build complete."
echo "Binary: $BUILD/u-boot.bin"
popd >/dev/null
