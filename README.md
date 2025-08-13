# VS Code Devcontainer: QEMU + U-Boot Lab (Ubuntu 22.04)

This project sets up a clean, reproducible environment in a VS Code **Dev Container** (Ubuntu 22.04) for a Day-1 flow with U-Boot (sandbox + QEMU ARM64) and a ready-to-use **debugger** integration (QEMU GDB server + `gdb-multiarch`).

## Quick Start

1. **Open the folder in a Dev Container**
   - VS Code → `File → Open Folder…` → select this project → **Reopen in Container**.

2. **Install toolchain & tools (inside the container)**
   - Run task: **Setup (toolchain + QEMU + DTC)**
     *(or manually)*:
     ```bash
     bash scripts/setup.sh
     ```
     This will:
     - Clone U-Boot at a fixed commit
     - Build QEMU **9.0.2**
     - Fetch **Arm GNU Toolchain 12.3** (AArch64)
     - Build **DTC v1.6.0** (with `-Werror` removed)

3. **(Optional) Export environment for manual builds**
   - If you build from the terminal by hand:
     ```bash
     source scripts/env.sh
     ```

4. **Build U-Boot**
   - **Sandbox (out-of-tree)**: Run task **Build U-Boot (Sandbox, out-of-tree)**
     *(or)* `bash scripts/build_uboot_sandbox.sh`
   - **QEMU ARM64 (out-of-tree)**: Run task **Build U-Boot (QEMU ARM64, out-of-tree)**
     *(or)* `bash scripts/build_uboot_qemu_arm64.sh`
     Output: `Day1/u-boot/build/u-boot.bin`

5. **Run U-Boot**
   - **Sandbox**: Run task **Run U-Boot (Sandbox)**
     *(ensure `scripts/run_sanbox_uboot.sh` exists and is executable)*.
   - **QEMU (no debugger)**: Run task **Run QEMU (U-Boot)**
     *(or)* `bash scripts/run_qemu_uboot.sh`

## Debugging U-Boot in QEMU (VS Code)

This project provides a launch config named **Debug U-Boot (QEMU ARM64)** that attaches GDB to QEMU’s GDB server.

### One-key flow (recommended)
- Press **F5** and select **Debug U-Boot (QEMU ARM64)**.
  The launch config will:
  1) Start the background task **Run QEMU (wait for GDB)**, which launches QEMU with `-S -s` and prints:
     ```
     [run_qemu] Starting QEMU waiting for GDB on tcp::1234 ...
     ```
     (The task’s problem matcher marks the task “ready” when it sees `tcp::1234`.)
  2) Attach **`gdb-multiarch`** to `localhost:1234` and load symbols from `Day1/u-boot/build/u-boot`.

### Under the hood (matching your `launch.json`)
- Debugger: `"miDebuggerPath": "gdb-multiarch"` (Ubuntu 22.04 native; avoids Python embedding issues).
- Environment in launch: sets `PYTHONHOME=/usr` (harmless with `gdb-multiarch`).
- Pre-launch task: **Run QEMU (wait for GDB)** (background via problem matcher).
- Working dir and program:
  - `program`: `${workspaceFolder}/Day1/u-boot/build/u-boot` (ELF with symbols)
  - `cwd`: `${workspaceFolder}/Day1/u-boot/build`

### Tips
- Early breakpoints: `_start`, `reset`, `board_init_f`, `relocate_code`, `board_init_r`.
- For **line breakpoints in `.S`**, enable DWARF:
  ```bash
  # inside container
  make -C Day1/u-boot mrproper
  make -C Day1/u-boot O=build qemu_arm64_defconfig
  echo 'CONFIG_DEBUG_INFO=y' >> Day1/u-boot/build/.config
  make -C Day1/u-boot O=build olddefconfig
  make -C Day1/u-boot O=build -j"$(nproc)"
  ```
- U-Boot **relocates** itself; if you set breakpoints *after* relocation, you may need to re-set them or use symbol breakpoints rather than line numbers.

## VS Code Tasks (as configured)

Use `Ctrl+Shift+P → Tasks: Run Task` for:

- **Setup (toolchain + QEMU + DTC)** → `bash scripts/setup.sh`
- **Build U-Boot (Sandbox, out-of-tree)** → `bash scripts/build_uboot_sandbox.sh`
- **Build U-Boot (QEMU ARM64, out-of-tree)** → `bash scripts/build_uboot_qemu_arm64.sh`
- **Run QEMU (U-Boot)** → `bash scripts/run_qemu_uboot.sh`
- **Run QEMU (wait for GDB)** *(background, started by the debugger)* → `bash scripts/run_qemu_uboot.sh -gdb`
- **Run U-Boot (Sandbox)** → `bash scripts/run_sanbox_uboot.sh` *(ensure the script exists; note the file name spelling)*
- **Run Stop QEMU** → `bash stop_qemu.sh`

## Notes
- The environment is deliberately **not** auto-sourced; run `source scripts/env.sh` when you need it for manual CLI builds.
- Both sandbox and QEMU ARM64 builds use an **out-of-tree** dir (`O=build`) to keep sources clean.
- Debugger defaults to **`gdb-multiarch`** to avoid issues with the Arm toolchain GDB’s embedded Python on Ubuntu 22.04.