import argparse
import logging
import os
import shutil
from pathlib import Path

logging.basicConfig(
    level=logging.DEBUG,
    format="%(levelname)s - %(message)s",
    filename="../log/create_symlinks.log",
    filemode="w",
)


def copy_scripts(source_dir: Path, dest_dir: Path) -> list[str]:
    dest_dir.mkdir(parents=True, exist_ok=True)
    copied_files: list[str] = []
    for file in source_dir.iterdir():
        if file.is_file() and os.access(file, os.X_OK):
            dest_file = dest_dir / file.name
            if dest_file.exists():
                logging.warning(f"File {dest_file} already exists. Skipping copy.")
                continue
            try:
                shutil.copy2(file, dest_file)
                Path.chmod(dest_file, 0o755)
                copied_files.append(file.name)
                logging.info(f"Copied: {file.name}")
            except Exception:
                logging.exception(f"Failed to copy {file}")
    return copied_files


def create_symlinks(script_dir: Path, link_dir: Path) -> None:
    for file in script_dir.iterdir():
        if file.is_file() and os.access(file, os.X_OK):
            target_link = link_dir / file.name
            if not target_link.exists():
                try:
                    os.symlink(file, target_link)
                    logging.info(f"Symlink created for {file} -> {target_link}")
                except OSError:
                    logging.exception(f"Failed to create symlink for {file}")
            else:
                logging.warning(f"Symlink for {file.name} already exists.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Copy executable scripts and create symlinks.",
    )
    parser.add_argument(
        "--source",
        type=Path,
        default=Path("/home/wasd/.scripts"),
        help="The directory to copy scripts from.",
    )
    parser.add_argument(
        "--destination",
        type=Path,
        default=Path("/usr/local/bin"),
        help="The directory to copy scripts to and create symlinks in.",
    )
    args = parser.parse_args()

    copied = copy_scripts(args.source, args.destination)
    logging.info(f"Files copied: {len(copied)}")

    create_symlinks(args.source, args.destination)


if __name__ == "__main__":
    main()
