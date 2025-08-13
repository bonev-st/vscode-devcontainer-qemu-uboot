# VS Code Devcontainer: QEMU + U-Boot Lab (Ubuntu 22.04)

This project sets up a clean, reproducible environment in a VS Code Dev Container on Ubuntu 22.04 to follow a Day 1 lab flow for U-Boot (sandbox + QEMU ARM64).

## Quick Start

1. **Open folder in Dev Container**
   - In VS Code: `File → Open Folder…` → select this project → "Reopen in Container".

2. **Run setup (inside container)**
   - `bash scripts/setup.sh`
     - Clones U-Boot at a fixed commit
     - Builds QEMU 9.0.2
     - Fetches Arm GNU Toolchain 12.3 (AArch64)
     - Builds DTC v1.6.0 (removes `-Werror`)

3. **Export environment**
   - `source scripts/env.sh`

4. **Build U-Boot (Sandbox)**
   - `bash scripts/build_uboot_sandbox.sh`
   - Run: `./Day1/u-boot/u-boot`

5. **Build U-Boot for QEMU ARM64 (out-of-tree)**
   - `bash scripts/build_uboot_qemu_arm64.sh`
   - Output: `Day1/u-boot/build/u-boot.bin`

6. **Run in QEMU**
   - `bash scripts/run_qemu_uboot.sh`

## VS Code Tasks
Use `Ctrl+Shift+P → Tasks: Run Task` to execute any of:
- Setup (toolchain + QEMU + DTC)
- Build U-Boot (Sandbox)
- Build U-Boot (QEMU ARM64, out-of-tree)
- Run QEMU (U-Boot)

## Notes
- The environment is deliberately **not** auto-sourced; run `source scripts/env.sh` when needed for explicit control.
- Out-of-tree build is used for the QEMU target (`O=build`), keeping the source tree clean.
- You can add your own custom U-Boot command under `Day1/u-boot/cmd/` and rebuild.
