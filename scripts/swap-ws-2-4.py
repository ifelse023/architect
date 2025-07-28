#!/usr/bin/env python3
import json
import subprocess
import sys

WORKSPACE_A = 2
WORKSPACE_B = 4


def hyprctl_json(*args):
    try:
        result = subprocess.run(
            ["hyprctl", "-j", *args], capture_output=True, text=True, check=True
        )
    except subprocess.CalledProcessError as e:
        print(e.stderr or str(e), file=sys.stderr)
        sys.exit(e.returncode)
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as e:
        print(f"Invalid JSON: {e}", file=sys.stderr)
        sys.exit(1)


def hyprctl_dispatch(*args):
    try:
        subprocess.run(["hyprctl", "dispatch", *args], check=True)
    except subprocess.CalledProcessError as e:
        print(f"dispatch error: {e}", file=sys.stderr)
        sys.exit(e.returncode)


def swap_workspaces(a: int, b: int):
    clients = hyprctl_json("clients")
    addrs_a = [c["address"] for c in clients if c.get("workspace", {}).get("id") == a]
    addrs_b = [c["address"] for c in clients if c.get("workspace", {}).get("id") == b]
    for addr in addrs_a:
        hyprctl_dispatch("movetoworkspace", f"{b},address:{addr}")
    for addr in addrs_b:
        hyprctl_dispatch("movetoworkspace", f"{a},address:{addr}")


if __name__ == "__main__":
    swap_workspaces(WORKSPACE_A, WORKSPACE_B)
