#!/usr/bin/env bash
set -euo pipefail

echo "[postCreate] Creating workspace directories..."
mkdir -p /workspaces/project/{scripts,.vscode,Day1}

echo "[postCreate] Done."
echo
echo "Next steps inside the container:"
echo "  1) bash scripts/setup.sh         # Install toolchain, clone U-Boot, build QEMU & DTC"
echo "  2) source scripts/env.sh         # Export ARCH/CROSS_COMPILE/PATH"
echo "  3) Run VS Code tasks (Ctrl+Shift+P → Tasks: Run Task)"
