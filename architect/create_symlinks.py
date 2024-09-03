import os
import shutil
import sys
from pathlib import Path


def copy_scripts() -> list[str]:
    source_dir = Path("/home/wasd/architect/scripts")
    dest_dir = Path("/home/wasd/.scripts")
    dest_dir.mkdir(parents=True, exist_ok=True)
    copied_files: list[str] = []

    for file in source_dir.iterdir():
        if file.is_file():
            try:
                dest_file = dest_dir / file.name
                shutil.copy2(file, dest_file)
                copied_files.append(file.name)
                print(f"Copied: {file.name}")
            except (OSError, shutil.Error) as e:
                print(f"Error copying {file.name}: {e}", file=sys.stderr)

    return copied_files


def make_files_executable(directory: str) -> None:
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = Path(root) / file
            try:
                file_path.chmod(0o755)
            except OSError as e:
                print(f"Error making {file_path} executable: {e}", file=sys.stderr)


def create_symlinks(script_dir: Path, link_dir: Path) -> None:
    for file in script_dir.iterdir():
        if file.is_file() and file.stat().st_mode & 0o111:
            target_link = link_dir / file.name
            if not target_link.exists():
                try:
                    target_link.symlink_to(file)
                    print(f"Symlink created for {file} -> {target_link}")
                except OSError as e:
                    print(
                        f"Failed to create symlink for {file}: {e}",
                        file=sys.stderr,
                    )
            else:
                print(f"Symlink for {file.name} already exists.")


def main(script_dir_path: str, link_dir_path: str) -> None:
    try:
        make_files_executable("/home/wasd/.scripts")
    except OSError as e:
        print(f"Error making files executable: {e}", file=sys.stderr)

    script_dir = Path(script_dir_path)
    link_dir = Path(link_dir_path)
    try:
        create_symlinks(script_dir, link_dir)
    except OSError as e:
        print(f"Error creating symlinks: {e}", file=sys.stderr)


if __name__ == "__main__":
    main("/home/wasd/.scripts", "/usr/local/bin")
