#!/usr/bin/env bash
set -euo pipefail

PID_FILE="/tmp/qemu-uboot.pid"

if [[ -f "$PID_FILE" ]]; then
  QPID="$(cat "$PID_FILE" || true)"
else
  QPID=""
fi

if [[ -n "${QPID:-}" ]] && ps -p "$QPID" -o comm= | grep -q "qemu-system-aarch64"; then
  echo "[stop_qemu] Stopping QEMU pid=$QPID (SIGTERM)"
  kill "$QPID" || true
  sleep 1
  if ps -p "$QPID" > /dev/null 2>&1; then
    echo "[stop_qemu] Forcing QEMU pid=$QPID (SIGKILL)"
    kill -9 "$QPID" || true
  fi
  rm -f "$PID_FILE"
  exit 0
fi

# Fallback: kill any qemu-system-aarch64 (inside this container)
PIDS="$(pgrep -f qemu-system-aarch64 || true)"
if [[ -n "$PIDS" ]]; then
  echo "[stop_qemu] Fallback: stopping pids: $PIDS"
  kill $PIDS || true
  sleep 1
  if pgrep -f qemu-system-aarch64 > /dev/null 2>&1; then
    echo "[stop_qemu] Fallback: force kill"
    pkill -9 -f qemu-system-aarch64 || true
  fi
  rm -f "$PID_FILE"
else
  echo "[stop_qemu] No qemu-system-aarch64 processes found."
fi
