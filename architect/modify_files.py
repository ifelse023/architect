import logging
from pathlib import Path

logging.basicConfig(
    level=logging.DEBUG,
    format="%(levelname)s - %(message)s",
    filename="./log/modify_files.log",
    filemode="w",
)


def modify_kernel_config(
    file_path: Path,
    replacements: list[tuple[str, str]],
    new_options: str = "i915.enable_guc=3 enable_fbc=1 i915.enable_dc=0 nowatchdog mitigations=off nopti tsx=on",
) -> None:
    try:
        with file_path.open("r+") as file:
            lines = file.readlines()
            modified_lines = []
            options_appended = False
            for line in lines:
                original_line = line
                for old, new in replacements:
                    if old in line:
                        line = line.replace(old, new)
                        logging.info(f"Replaced '{old}' with '{new}' in {file_path}")
                if original_line.strip().startswith("options"):
                    line = original_line.strip() + " " + new_options + "\n"
                    options_appended = True
                modified_lines.append(line)
            if not options_appended:
                modified_lines.append("options " + new_options + "\n")
                logging.debug(f"Added new kernel options line in {file_path}")
            file.seek(0)
            file.writelines(modified_lines)
            file.truncate()
    except FileNotFoundError:
        logging.exception("File not found")
        raise
    except PermissionError:
        logging.exception("Permission denied")
        raise
    except Exception:
        logging.exception("Error modifying kernel configuration")
        raise


def find_boot_entry_file(directory: Path) -> Path | None:
    try:
        files = [f for f in directory.iterdir() if f.is_file()]
        if not files:
            logging.warning(f"No files found in the directory: {directory}")
            return None
        file_path = files[0]
        logging.debug(f"Selected file for modification: {file_path}")
        return file_path
    except Exception:
        logging.exception("Error finding boot entry file")
        return None


def main(boot_entries_path: Path = Path("/boot/loader/entries/")) -> None:
    try:
        if not boot_entries_path.exists():
            logging.error(f"Directory not found: {boot_entries_path}")
            return
        file_path = find_boot_entry_file(boot_entries_path)
        if not file_path:
            return
        replacements = [
            ("vmlinuz-linux", "vmlinuz-linux-cachyos"),
            ("initramfs-linux.img", "initramfs-linux-cachyos.img"),
        ]
        # modify_kernel_config(file_path, replacements)
    except Exception:
        logging.exception("error")


if __name__ == "__main__":
    main()
