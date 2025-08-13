#!/usr/bin/env bash
set -euo pipefail
ROOT="/workspaces/project"
QEMU_VER="9.0.2"
UBOOT_BUILD="$ROOT/Day1/u-boot/build"

GDB_OPTS=""
if [[ "${1:-}" == "-gdb" ]]; then
  # -S: freeze CPU at startup; -s: shorthand for "-gdb tcp::1234"
  GDB_OPTS="-S -s"
  echo "[run_qemu] Starting QEMU waiting for GDB on tcp::1234 ..."
fi

if [ ! -f "$UBOOT_BUILD/u-boot.bin" ]; then
  echo "u-boot.bin not found. Run scripts/build_uboot_qemu_arm64.sh first."
  exit 1
fi

"$ROOT/qemu-$QEMU_VER/build/qemu-system-aarch64" \
  -M virt -cpu cortex-a35 -m 2G \
  -bios "$UBOOT_BUILD/u-boot.bin" \
  -nographic $GDB_OPTS
