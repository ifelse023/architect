#!/usr/bin/env python3
import json
import subprocess
import os
import sys


def load_package_data(config_path):
    try:
        with open(config_path, "r") as f:
            package_data = json.load(f)
    except FileNotFoundError:
        sys.exit(f"Error: Configuration file '{config_path}' not found.")
    except json.JSONDecodeError:
        sys.exit(f"Error: Configuration file '{config_path}' contains invalid JSON.")

    required_keys = ["packages", "semester-packages", "aur-packages"]
    missing_keys = [key for key in required_keys if key not in package_data]
    if missing_keys:
        sys.exit(
            f"Error: Configuration missing required keys: {', '.join(missing_keys)}"
        )

    return package_data


def run_command(cmd, description):
    print(f"\n==> {description}")

    try:
        subprocess.run(cmd, check=True)
        print(f"✓ {description} completed")
    except subprocess.CalledProcessError as e:
        print(f"✗ Error during {description}: {e}")
        sys.exit(1)


def install_packages(install_later=False):
    config_path = os.path.join(os.environ["HOME"], "architect/packages.json")
    package_data = load_package_data(config_path)

    official_packages = package_data["packages"]
    semester_packages = package_data["semester-packages"]
    aur_packages = package_data["aur-packages"]
    later_packages = package_data.get("later-packages", [])

    if install_later:
        if later_packages:
            run_command(
                ["paru", "-S", "--needed"] + later_packages,
                "Installing later packages with paru",
            )
        else:
            print("No later packages defined in configuration.")
    else:
        all_official = official_packages + semester_packages
        if all_official:
            run_command(
                ["sudo", "pacman", "-S", "--needed"] + all_official,
                "Installing official and semester packages",
            )

        if aur_packages:
            run_command(
                ["paru", "-S", "--needed"] + aur_packages, "Installing AUR packages"
            )


if __name__ == "__main__":
    install_later = "--later" in sys.argv
    install_packages(install_later)
