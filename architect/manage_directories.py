#!/usr/bin/env python3
import sys
import logging
from pathlib import Path
from shutil import rmtree
import argparse


def manage_directories(
    home_path: Path, dirs_to_keep: set[str], dry_run: bool = False
) -> int:
    try:
        existing_dirs: set[str] = {
            item.name
            for item in home_path.iterdir()
            if item.is_dir() and not item.name.startswith(".")
        }

        dirs_to_remove = existing_dirs - dirs_to_keep

        for dir_name in dirs_to_remove:
            dir_path = home_path / dir_name
            if dry_run:
                logging.info(f"Would delete directory: {dir_path}")
            else:
                try:
                    rmtree(dir_path)
                    logging.info(f"Deleted directory: {dir_path}")
                except PermissionError:
                    logging.error(f"Permission denied when deleting: {dir_path}")
                    return 1

        for dir_name in dirs_to_keep:
            dir_path = home_path / dir_name
            if not dir_path.exists():
                if dry_run:
                    logging.info(f"Would create directory: {dir_path}")
                else:
                    dir_path.mkdir(parents=True, exist_ok=True)
                    logging.info(f"Created directory: {dir_path}")

        return 0
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        return 1


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Manage directories in your home folder"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes",
    )
    parser.add_argument(
        "--verbose", action="store_true", help="Increase output verbosity"
    )
    args = parser.parse_args()

    log_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=log_level, format="%(levelname)s: %(message)s")

    dirs_to_keep: set[str] = {".", "architect", "Downloads", "dev", "misc"}
    home_dir = Path.home()

    if not args.dry_run:
        to_delete = {
            item.name
            for item in home_dir.iterdir()
            if item.is_dir()
            and not item.name.startswith(".")
            and item.name not in dirs_to_keep
        }

        if to_delete:
            logging.info(
                f"The following directories will be deleted: {', '.join(to_delete)}"
            )
            confirmation = input("Are you sure you want to proceed? (y/n): ").lower()

            if confirmation != "y":
                logging.info("Operation cancelled.")
                return 0

    return manage_directories(home_dir, dirs_to_keep, args.dry_run)


if __name__ == "__main__":
    sys.exit(main())
