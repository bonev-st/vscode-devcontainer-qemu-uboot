#!/usr/bin/env bash
set -euo pipefail
ROOT="/workspaces/project"
QEMU_VER="9.0.2"
UBOOT_BUILD="$ROOT/Day1/u-boot/build"

if [ ! -f "$UBOOT_BUILD/u-boot" ]; then
  echo "u-boot not found. Run scripts/build_uboot_sandbox.sh first."
  exit 1
fi

"$UBOOT_BUILD/u-boot"
