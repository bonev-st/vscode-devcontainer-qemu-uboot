#!/usr/bin/env bash
# Manual env exports (preferred for explicit control)
ROOT="/workspaces/project"
export ARCH=arm64
export DTC_FLAGS="-@"
export PATH="$ROOT/gcc-linaro-aarch64/bin:$ROOT/dtc:$PATH"
export CROSS_COMPILE=aarch64-none-linux-gnu-

echo "Environment configured:"
echo "  ARCH=$ARCH"
echo "  CROSS_COMPILE=$CROSS_COMPILE"
echo "  DTC_FLAGS=$DTC_FLAGS"
echo "  PATH updated with toolchain and dtc"
