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
            dest_file = dest_dir / file.name
            shutil.copy2(file, dest_file)
            copied_files.append(file.name)
            print(f"Copied: {file.name}")
    return copied_files


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
    copied: list[str] = copy_scripts()
    print(f"Files copied: {len(copied)}")

    script_dir = Path(script_dir_path)
    link_dir = Path(link_dir_path)
    create_symlinks(script_dir, link_dir)


if __name__ == "__main__":
    main("/home/wasd/.scripts", "/usr/local/bin")
