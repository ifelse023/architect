import json
import logging
import subprocess
from pathlib import Path

logging.basicConfig(
    level=logging.DEBUG,
    format="%(levelname)s - %(message)s",
    filename="../log/install_packages.log",
    filemode="w",
)


def install_packages() -> None:
    with Path(Path.home(), "architect/packages.json").open() as file:
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
    try:
        subprocess.run(pacman_command, check=True)
        logging.info("Installed packages :)")
    except subprocess.CalledProcessError:
        logging.exception("Failed to install packages. :(")
    try:
        subprocess.run(aur_command, check=True)
        logging.info("Installed AUR packages :)")
    except subprocess.CalledProcessError:
        logging.exception("Failed to install AUR packages. :(")


install_packages()
