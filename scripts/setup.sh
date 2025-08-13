#!/usr/bin/env bash
set -euo pipefail

ROOT="/workspaces/project"
DAY1="$ROOT/Day1"
QEMU_VER="9.0.2"
TOOLCHAIN_DIR="$ROOT/gcc-linaro-aarch64"
DTC_DIR="$ROOT/dtc"

mkdir -p "$DAY1"
cd "$ROOT"

echo "[setup] Cloning U-Boot (shallow) into Day1/u-boot ..."
if [ ! -d "$DAY1/u-boot" ]; then
  git clone --depth 1 https://source.denx.de/u-boot/u-boot.git "$DAY1/u-boot"
  pushd "$DAY1/u-boot" >/dev/null
  # Checkout specific commit from the lab for reproducibility
  git fetch --depth 1 origin 9d3f1ebaf8751f0287b5d02158cc706435f8fb19
  git checkout 9d3f1ebaf8751f0287b5d02158cc706435f8fb19
  popd >/dev/null
else
  echo "[setup] U-Boot already present, skipping."
fi

echo "[setup] Downloading and building QEMU $QEMU_VER ..."
if [ ! -d "$ROOT/qemu-$QEMU_VER" ]; then
  wget -q https://download.qemu.org/qemu-$QEMU_VER.tar.xz -O "$ROOT/qemu-$QEMU_VER.tar.xz"
  tar xf "$ROOT/qemu-$QEMU_VER.tar.xz" -C "$ROOT"
  pushd "$ROOT/qemu-$QEMU_VER" >/dev/null
  ./configure
  make -j"$(nproc)"
  popd >/dev/null
else
  echo "[setup] QEMU already present, skipping."
fi

echo "[setup] Retrieving Arm GNU toolchain 12.3 for aarch64 ..."
if [ ! -d "$TOOLCHAIN_DIR" ]; then
  # Use the same filename as in the lab doc
  TOOL_URL="https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz?rev=cf8baa0ef2e54e9286f0409cdda4f66c&hash=4E1BA6BFC2C09EA04DBD36C393C9DD3A"
  wget -q -O "$ROOT/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz" "$TOOL_URL"
  tar xf "$ROOT/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz" -C "$ROOT"
  ln -s "$ROOT/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu" "$TOOLCHAIN_DIR"
else
  echo "[setup] Toolchain already present, skipping."
fi

echo "[setup] Cloning and building DTC v1.6.0 ..."
if [ ! -d "$DTC_DIR" ]; then
  git clone git://git.kernel.org/pub/scm/utils/dtc/dtc.git -b v1.6.0 "$DTC_DIR"
  pushd "$DTC_DIR" >/dev/null
  # Remove -Werror from Makefile to match lab note
  sed -i 's/-Werror//g' Makefile || true
  make -j"$(nproc)"
  popd >/dev/null
else
  echo "[setup] DTC already present, skipping."
fi

echo "[setup] All set. You can now 'source scripts/env.sh'."
