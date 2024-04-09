import requests
import tarfile
import subprocess
import os
import json
from systemd_manager import enable_service
import shutil


def manage_directories():
    dirs_to_keep = ["architect", "Downloads", "Documents", "projects"]
    home_dir = "/home/wasd/"
    try:
        for item in os.listdir(home_dir):
            item_path = os.path.join(home_dir, item)
            if item.startswith(".") or not os.path.isdir(item_path):
                continue
            if item not in dirs_to_keep:
                shutil.rmtree(item_path)
                print(f"Deleted: {item_path}")
        for dir_name in dirs_to_keep:
            dir_path = os.path.join(home_dir, dir_name)

            if not os.path.exists(dir_path):
                os.makedirs(dir_path, exist_ok=True)
                print(f"Created: {dir_path}")

    except Exception as e:
        print(f"An error occurred: {e}")


def install_packages():
    with open("./packages.json", "r") as file:
        data = json.load(file)

    official_packages = data["packages"]
    aur_packages = data["aur-packages"]

    pacman_command = [
        "sudo",
        "pacman",
        "-S",
        "--needed",
        "--noconfirm",
    ] + official_packages
    aur_command = ["paru", "-S", "--needed", "--noconfirm"] + aur_packages

    print("Installing official repository packages...")
    subprocess.run(pacman_command)

    print("Installing AUR packages...")
    subprocess.run(aur_command)


def main():
    services = [
        "thermald",
        "acpid.service",
        "irqbalance",
        "keyd",
        "power-profiles-daemon.service",
    ]
    print("Starting post-installation script...")

    install_packages()
    for service in services:
        enable_service(service)
    print("Post-installation script completed successfully.")

    manage_directories()


if __name__ == "__main__":
    main()
