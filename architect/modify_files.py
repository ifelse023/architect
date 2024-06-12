from os import listdir, path as os_path


def append_options_to_kernel_config(
    file_path, new_options="nowatchdog mitigations=off nopti tsx=on"
):
    try:
        with open(file_path, "r+") as file:
            lines = file.readlines()
            file.seek(0)
            for line in lines:
                if line.strip().startswith("options"):
                    line = line.strip() + " " + new_options + "\n"
                file.write(line)
        print("Options appended successfully.")
    except Exception as e:
        print(f"Error occurred while modifying the file: {e}")


def replace(file_path, replacements):
    try:
        with open(file_path, "r+") as file:
            lines = file.readlines()
            file.seek(0)
            for line in lines:
                for old, new in replacements:
                    line = line.replace(old, new)
                file.write(line)
            file.truncate()
        print("File modified successfully.")
    except Exception as e:
        print(f"Error occurred while modifying the file: {e}")


def main():
    boot_entries_path = "/boot/loader/entries/"
    files = listdir(boot_entries_path)
    if not files:
        print("No files found in the directory: " + boot_entries_path)
        return
    file_path = os_path.join(boot_entries_path, files[0])
    replace("/etc/fstab", [("relatime", "noatime")])

    replacements = [
        ("vmlinuz-linux", "vmlinuz-linux-cachyos"),
        ("initramfs-linux.img", "initramfs-linux-cachyos.img"),
    ]
    replace(file_path, replacements)
    append_options_to_kernel_config(file_path)


main()
