import subprocess
import json
from systemd_manager import enable_service


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
        "power-profiles-daemon.service",
    ]
    print("Starting post-installation script...")

    install_packages()
    for service in services:
        enable_service(service)
    print("Post-installation script completed successfully.")


if __name__ == "__main__":
    main()
