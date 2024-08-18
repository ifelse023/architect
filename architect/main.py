import json
import subprocess

from systemd_manager import enable_service


def install_packages() -> None:
    with open("./packages.json") as file:
        data = json.load(file)

    official_packages = data["packages"]
    aur_packages = data["aur-packages"]

    pacman_command = [
        "sudo",
        "pacman",
        "-S",
        "--needed",
        "--noconfirm",
        *official_packages,
    ]
    aur_command = ["paru", "-S", "--needed", *aur_packages]

    print("Installing official repository packages...")
    subprocess.run(pacman_command, check=False)

    print("Installing AUR packages...")
    subprocess.run(aur_command, check=False)


def main() -> None:
    services = [
        "tlp",
        "thermald",
        "irqbalance",
        "scx",
    ]
    print("Starting post-installation script...")

    install_packages()
    for service in services:
        enable_service(service)
    print("Post-installation script completed successfully.")


if __name__ == "__main__":
    main()
