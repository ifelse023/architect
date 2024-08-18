from os import listdir
from os import path as os_path


def modify_kernel_config(
    file_path,
    replacements,
    new_options: str = "i915.enable_guc=3 enable_fbc=1 i915.enable_dc=0 nowatchdog mitigations=off nopti tsx=on",
) -> None:
    try:
        with open(file_path, "r+") as file:
            lines = file.readlines()
            modified_lines = []
            options_appended = False

            for line in lines:
                for old, new in replacements:
                    line = line.replace(old, new)
                if line.strip().startswith("options"):
                    line = line.strip() + " " + new_options + "\n"
                    options_appended = True
                modified_lines.append(line)

            if not options_appended:
                modified_lines.append("options " + new_options + "\n")

            file.seek(0)
            file.writelines(modified_lines)
            file.truncate()

    except Exception as e:
        print(f"Error occurred: {e}")
        raise


def main() -> None:
    boot_entries_path = "/boot/loader/entries/"
    try:
        files = listdir(boot_entries_path)
        if not files:
            print("No files found in the directory: " + boot_entries_path)
            return

        file_path = os_path.join(boot_entries_path, files[0])
        replacements = [
            ("vmlinuz-linux", "vmlinuz-linux-cachyos"),
            ("initramfs-linux.img", "initramfs-linux-cachyos.img"),
        ]

        modify_kernel_config(file_path, replacements)
    except Exception as e:
        print(f"An error occurred in main: {e}")


main()
