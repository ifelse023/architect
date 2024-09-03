import logging
import sys
from pathlib import Path
from shutil import rmtree

logging.basicConfig(
    level=logging.DEBUG,
    format="%(levelname)s - %(message)s",
    filename="./log/manage_directories.log",
    filemode="w",
)


def manage_directories() -> None:
    dirs_to_keep: set[str] = {".", "architect", "Downloads", "dev", "misc"}
    home_dir = Path("/home/wasd/")

    try:
        existing_dirs: set[str] = {
            item.name
            for item in home_dir.iterdir()
            if item.is_dir() and not item.name.startswith(".")
        }

        for dir_name in existing_dirs - dirs_to_keep:
            dir_path = home_dir / dir_name
            rmtree(dir_path)
            logging.info(f"Deleted directory: {dir_path}")

        for dir_name in dirs_to_keep:
            dir_path = home_dir / dir_name
            if not dir_path.exists():
                dir_path.mkdir(parents=True, exist_ok=True)
                logging.info(f"Created directory: {dir_path}")

    except Exception:
        logging.exception("Failed")
        sys.exit(1)


manage_directories()
